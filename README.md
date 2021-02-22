# Tips

Elixir Tips and Tricks from the Experience of Development.

**TODO: Add description**

Checkout some cherry picked tips from the all Parts.

```
bash> mix new tips --sup
bash> iex -S mix
```

### ETS powered page cache

```
Clients read directly     The table holds `{key, value}` cache items.
from the table.           ╔═════════════════════╗
            ╔═════════════║      ETS table      ║
            ║             ╚═════════════════════╝
            ║             PageCache creates the table and writes to it
╔═════════════════════╗   ╔═════════════════════╗
║        CLIENTS      ║═══║      PageCache      ║
╚═════════════════════╝   ╚═════════════════════╝
Writes are delegated to the page cache process
```

```
iex> {:ok, pid} = Tips.EtsPageCache.start_link
iex> Tips.EtsPageCache.cached(:index, &Tips.WebServer.index/0)
iex> Tips.EtsPageCache.cached(:index, &Tips.WebServer.index/0)
iex> Tips.Profiler.run(Tips.EtsPageCache, 100_000)
iex> Tips.Profiler.run(Tips.EtsPageCache, 100_000, 100)

iex> {:ok, pid} = Tips.PageCache.start_link
iex> Tips.PageCache.cached(:index, &Tips.WebServer.index/0)
iex> Tips.PageCache.cached(:index, &Tips.WebServer.index/0)
iex> Tips.Profiler.run(Tips.PageCache, 100_000)
iex> Tips.Profiler.run(Tips.PageCache, 100_000, 100)
```

#### 20 Feb 2021 by Oleg G.Kapranov
