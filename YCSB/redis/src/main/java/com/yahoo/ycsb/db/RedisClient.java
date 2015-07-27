/**
 * Redis client binding for YCSB.
 *
 * All YCSB records are mapped to a Redis *hash field*.  For scanning
 * operations, all keys are saved (by an arbitrary hash) in a sorted set.
 */

package com.yahoo.ycsb.db;
import com.yahoo.ycsb.DB;
import com.yahoo.ycsb.DBException;
import com.yahoo.ycsb.ByteIterator;
import com.yahoo.ycsb.StringByteIterator;

import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.Vector;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisCommands;
import redis.clients.jedis.JedisShardInfo;
import redis.clients.jedis.ShardedJedis;
import redis.clients.jedis.Protocol;

public class RedisClient extends DB {

    // The jedis object refers to either an instance of Jedis or ShardedJedis.
    private JedisCommands jedis;

    // If HOST_PROPERTY is set, we'll use a single Redis server.
    public static final String HOST_PROPERTY = "redis.host";

    // If SHARDEDHOSTS_PROPERTY is set, we'll configure Jedis to shard the
    // data across multiple servers.
    public static final String SHARDEDHOSTS_PROPERTY = "redis.shardedHosts";

    // If we're using multiple sharded hosts, we assume the same port number and
    // password.
    public static final String PORT_PROPERTY = "redis.port";
    public static final String PASSWORD_PROPERTY = "redis.password";

    // If this property is set (to any value at all), indexing will be disabled.
    // This means two things: 1) scans cannot be done, and 2) extra redis operations
    // needed to support scans are elided, improving performance. When comparing
    // against systems that don't support scans, this is more appropriate.
    public static final String DISABLEINDEXING_PROPERTY = "redis.disableIndexing";

    private boolean disableIndexing = false;

    public static final String INDEX_KEY = "_indices";

    public void init() throws DBException {
        Properties props = getProperties();
        int port;
System.out.println("-- Using modified RedisClient --");
        String portString = props.getProperty(PORT_PROPERTY);
        if (portString != null) {
            port = Integer.parseInt(portString);
        }
        else {
            port = Protocol.DEFAULT_PORT;
        }

        String password = props.getProperty(PASSWORD_PROPERTY);

        String host = props.getProperty(HOST_PROPERTY);
        if (host != null) {
            Jedis j = new Jedis(host, port);
            j.connect();
            if (password != null) {
                j.auth(password);
            }
            jedis = j;
        } else {
            String hostsString = props.getProperty(SHARDEDHOSTS_PROPERTY);
            if (hostsString != null) {
                String[] hosts = hostsString.split(",");
                List<JedisShardInfo> shards = new ArrayList<JedisShardInfo>();
                for (String h : hosts) {
                    JedisShardInfo si = new JedisShardInfo(h, port);
                    if (password != null)
                        si.setPassword(password);
                    shards.add(si);
                }
                jedis = new ShardedJedis(shards);
            }
        }

        if (props.getProperty(DISABLEINDEXING_PROPERTY) != null)
            disableIndexing = true;
    }

    public void cleanup() throws DBException {
        // A little ugly. Sorry :(
        if (jedis instanceof Jedis)
            ((Jedis)jedis).disconnect();
        else
            ((ShardedJedis)jedis).disconnect();
    }

    /* Calculate a hash for a key to store it in an index.  The actual return
     * value of this function is not interesting -- it primarily needs to be
     * fast and scattered along the whole space of doubles.  In a real world
     * scenario one would probably use the ASCII values of the keys.
     */
    private double hash(String key) {
        return key.hashCode();
    }

    //XXX jedis.select(int index) to switch to `table`

    @Override
    public int read(String table, String key, Set<String> fields,
            HashMap<String, ByteIterator> result) {
        if (fields == null) {
            StringByteIterator.putAllAsByteIterators(result, jedis.hgetAll(key));
        }
        else {
            String[] fieldArray = (String[])fields.toArray(new String[fields.size()]);
            List<String> values = jedis.hmget(key, fieldArray);

            Iterator<String> fieldIterator = fields.iterator();
            Iterator<String> valueIterator = values.iterator();

            while (fieldIterator.hasNext() && valueIterator.hasNext()) {
                result.put(fieldIterator.next(),
			   new StringByteIterator(valueIterator.next()));
            }
            assert !fieldIterator.hasNext() && !valueIterator.hasNext();
        }
        return result.isEmpty() ? 1 : 0;
    }

    @Override
    public int insert(String table, String key, HashMap<String, ByteIterator> values) {
        if (jedis.hmset(key, StringByteIterator.getStringMap(values)).equals("OK")) {
            if (!disableIndexing)
                jedis.zadd(INDEX_KEY, hash(key), key);
            return 0;
        }
        return 1;
    }

    // Jedis and ShardedJedis don't have a common interface we can use to make
    // them perfectly interchangable. JedisCommands is close, but in 2.1.0 it
    // omits a definition for 'del'.
    //
    // This hackery should be wrapped up in its own class.
    private long 
    del(String key)
    {
        if (jedis instanceof Jedis)
            return ((Jedis)jedis).del(key);
        else
            return ((ShardedJedis)jedis).del(key);
    }

    @Override
    public int delete(String table, String key) {
        return del(key) == 0
            && (disableIndexing || jedis.zrem(INDEX_KEY, key) == 0)
               ? 1 : 0;
    }

    @Override
    public int update(String table, String key, HashMap<String, ByteIterator> values) {
        return jedis.hmset(key, StringByteIterator.getStringMap(values)).equals("OK") ? 0 : 1;
    }

    @Override
    public int scan(String table, String startkey, int recordcount,
            Set<String> fields, Vector<HashMap<String, ByteIterator>> result) {
        if (disableIndexing) {
            System.err.println("Scan attempted, but indexing was disabled via the " +
                DISABLEINDEXING_PROPERTY + " property -- cannot continue!");
            System.exit(1);
        }

        Set<String> keys = jedis.zrangeByScore(INDEX_KEY, hash(startkey),
                                Double.POSITIVE_INFINITY, 0, recordcount);

        HashMap<String, ByteIterator> values;
        for (String key : keys) {
            values = new HashMap<String, ByteIterator>();
            read(table, key, fields, values);
            result.add(values);
        }

        return 0;
    }

}
