import pytest
import redis

from . import retry


@pytest.fixture
def redisdb():
    def f():
        return redis.Redis(host='redis')
    return retry(f)


def test_redis(redisdb):
    redisdb.set('foo', 'test value')
    assert redisdb.get('foo') == b'test value'
