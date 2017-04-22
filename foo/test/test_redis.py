import pytest
import redis

from . import retry


@pytest.fixture
def redisdb() -> redis.Redis:
    def f() -> redis.Redis:
        return redis.Redis(host='redis')
    return retry(f)


def test_redis(redisdb: redis.Redis) -> None:
    redisdb.set('foo', 'test value')
    assert redisdb.get('foo') == b'test value'
