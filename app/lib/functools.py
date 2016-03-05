import time


def timeit(method):

    def timed(*args, **kw):
        start = time.time()
        result = method(*args, **kw)
        end = time.time()

        print '%r %2.4f sec' % \
              (method.__name__, end-start)
        return result

    return timed
