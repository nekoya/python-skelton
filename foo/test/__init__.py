import time
from typing import Any, Callable


def retry(fn: Callable[..., Any]) -> Any:
    retry_count: int = 20
    for i in range(retry_count):
        try:
            return fn()
        except Exception as e:
            remain: int = retry_count - i
            if remain == 0:
                raise e
            time.sleep(1)
