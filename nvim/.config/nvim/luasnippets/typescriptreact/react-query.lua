local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  PROVIDER                                                    ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "rqprovider", name = "React Query Provider", dscr = "QueryClientProvider wrapper component" },
        fmta([[
"use client";
// providers must be Client Components

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { useState, type ReactNode } from "react";

export default function <name>({ children }: { children: ReactNode }) {
    // useState prevents recreating client on re-renders
    const [queryClient] = useState(
        () =>>
            new QueryClient({
                defaultOptions: {
                    queries: {
                        staleTime: <stale_time>, // data stays fresh this long (ms) before refetching
                    },
                },
            })
    );

    return (
        <<QueryClientProvider client={queryClient}>>
            {children}
        <</QueryClientProvider>>
    );
}]], {
            name = i(1, "QueryProvider"),
            stale_time = i(2, "60 * 1000"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  QUERIES                                                     ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "rqquery", name = "React Query useQuery", dscr = "Client component with useQuery and loading/error states" },
        fmta([[
"use client";

import { useQuery } from "@tanstack/react-query";

export default function <name>() {
    const { data, isLoading, error } = useQuery({
        queryKey: [<query_key>], // cache key: data refetches when this changes
        queryFn: async () =>> { // function that fetches the data
            const res = await fetch("<url>");
            if (!res.ok) throw new Error("Failed to fetch");
            return res.json();
        },
    });

    if (isLoading) return <<div>>Loading...<</div>>;
    if (error) return <<div>>Error: {error.message}<</div>>;

    return (
        <<div>>
            <finish>
        <</div>>
    );
}]], {
            name = i(1, "MyComponent"),
            query_key = i(2, '"items"'),
            url = i(3, "/api/items"),
            finish = i(0),
        })
    ),

    s({ trig = "rqinfinite", name = "React Query useInfiniteQuery", dscr = "Infinite scroll with useInfiniteQuery and load more" },
        fmta([[
"use client";

import { useInfiniteQuery } from "@tanstack/react-query";

export default function <name>() {
    const {
        data,
        fetchNextPage,
        hasNextPage,
        isFetchingNextPage,
        isLoading,
        error,
    } = useInfiniteQuery({
        queryKey: [<query_key>], // cache key for the paginated query
        queryFn: async ({ pageParam }) =>> {
            const res = await fetch(`<url>?cursor=${pageParam}`);
            if (!res.ok) throw new Error("Failed to fetch");
            return res.json();
        },
        initialPageParam: <initial_param>, // starting cursor/page value
        getNextPageParam: (lastPage) =>> lastPage.<next_cursor>, // return undefined to signal no more pages
    });

    if (isLoading) return <<div>>Loading...<</div>>;
    if (error) return <<div>>Error: {error.message}<</div>>;

    return (
        <<div>>
            {data?.pages.map((page) =>>
                page.<items>.map((<item>) =>> (
                    <<div key={<item_r>.id}>>{<item_r2>.<field>}<</div>>
                ))
            )}
            {hasNextPage && (
                <<button onClick={() =>> fetchNextPage()} disabled={isFetchingNextPage}>>
                    {isFetchingNextPage ? "Loading more..." : "<load_btn>"}
                <</button>>
            )}
            <finish>
        <</div>>
    );
}]], {
            name = i(1, "InfiniteList"),
            query_key = i(2, '"items"'),
            url = i(3, "/api/items"),
            initial_param = i(4, "0"),
            next_cursor = i(5, "nextCursor"),
            items = i(6, "items"),
            item = i(7, "item"),
            item_r = rep(7), item_r2 = rep(7),
            field = i(8, "name"),
            load_btn = i(9, "Load more"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  MUTATIONS                                                   ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "rqmutation", name = "React Query useMutation", dscr = "useMutation with query invalidation" },
        fmta([[
const queryClient = useQueryClient(); // needed to invalidate cached queries

const <name> = useMutation({
    mutationFn: async (<params>: <param_type>) =>> { // runs when mutation.mutate() is called
        const res = await fetch("<url>", {
            method: "<method>",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(<body>),
        });
        if (!res.ok) throw new Error("Request failed");
        return res.json();
    },
    onSuccess: () =>> {
        queryClient.invalidateQueries({ queryKey: [<invalidate_key>] }); // refetch affected queries
        <finish>
    },
});]], {
            name = i(1, "mutation"),
            params = i(2, "values"),
            param_type = i(3, "FormValues"),
            url = i(4, "/api/items"),
            method = c(5, { t("POST"), t("PUT"), t("PATCH"), t("DELETE") }),
            body = rep(2),
            invalidate_key = i(6, '"items"'),
            finish = i(0),
        })
    ),
}
