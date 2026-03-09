local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local function to_camel(args)
    local name = args[1][1]
    if not name or name == "" then return "item" end
    return name:sub(1, 1):lower() .. name:sub(2)
end

local function to_camel_plural(args)
    local name = args[1][1]
    if not name or name == "" then return "items" end
    local camel = name:sub(1, 1):lower() .. name:sub(2)
    if camel:sub(-1) == "y" and not camel:sub(-2, -2):match("[aeiou]") then
        return camel:sub(1, -2) .. "ies"
    elseif camel:sub(-1) == "s" or camel:sub(-2) == "sh" or camel:sub(-2) == "ch"
        or camel:sub(-1) == "x" or camel:sub(-1) == "z" then
        return camel .. "es"
    else
        return camel .. "s"
    end
end

local function to_pascal_plural(args)
    local name = args[1][1]
    if not name or name == "" then return "Items" end
    if name:sub(-1) == "y" and not name:sub(-2, -2):match("[aeiou]") then
        return name:sub(1, -2) .. "ies"
    elseif name:sub(-1) == "s" or name:sub(-2) == "sh" or name:sub(-2) == "ch"
        or name:sub(-1) == "x" or name:sub(-1) == "z" then
        return name .. "es"
    else
        return name .. "s"
    end
end

local function to_kebab_plural(args)
    local name = args[1][1]
    if not name or name == "" then return "items" end
    local kebab = name:gsub("(%u+)(%u%l)", "%1-%2"):gsub("(%l)(%u)", "%1-%2"):lower()
    if kebab:sub(-1) == "y" and not kebab:sub(-2, -2):match("[aeiou]") then
        return kebab:sub(1, -2) .. "ies"
    elseif kebab:sub(-1) == "s" or kebab:sub(-2) == "sh" or kebab:sub(-2) == "ch"
        or kebab:sub(-1) == "x" or kebab:sub(-1) == "z" then
        return kebab .. "es"
    else
        return kebab .. "s"
    end
end

local function to_setter(args)
    local name = args[1][1]
    if not name or name == "" then return "setValue" end
    return "set" .. name:sub(1, 1):upper() .. name:sub(2)
end

return {

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  PAGES                                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "npage", name = "Next.js Page", dscr = "Basic page component (App Router)" },
        fmta([[
export default function <name>Page() {
    return (
        <<div>>
            <<h1>><title><</h1>>
            <finish>
        <</div>>
    );
}]], {
            name = i(1, ""),
            title = i(2, "Page Title"),
            finish = i(0),
        })
    ),

    s({ trig = "npageparams", name = "Next.js Dynamic Page", dscr = "Page with dynamic route params" },
        fmta([[
// params are async in Next.js 15+
type Props = {
    params: Promise<<{ <param>: string }>>;
};

export default async function <name>Page({ params }: Props) {
    const { <param_r> } = await params; // extract dynamic segment from URL

    return (
        <<div>>
            <<h1>>{<param_r2>}<</h1>>
            <finish>
        <</div>>
    );
}]], {
            param = i(1, "id"),
            name = i(2, ""),
            param_r = rep(1),
            param_r2 = rep(1),
            finish = i(0),
        })
    ),

    s({ trig = "nlayout", name = "Next.js Layout", dscr = "Nested layout component" },
        fmta([[
// layouts wrap child pages and persist across navigations
export default function <name>Layout({ children }: { children: React.ReactNode }) {
    return (
        <<div>>
            <finish>
            {children}
        <</div>>
    );
}]], {
            name = i(1, ""),
            finish = i(0),
        })
    ),

    s({ trig = "nlayoutroot", name = "Next.js Root Layout", dscr = "Root layout with metadata, html and body" },
        fmta([[
import type { Metadata } from "next";

// static metadata for SEO (title, description, etc.)
export const metadata: Metadata = {
    title: "<title>",
    description: "<description>",
};

// root layout wraps the entire app — required in app/layout.tsx
export default function RootLayout({ children }: { children: React.ReactNode }) {
    return (
        <<html lang="en">>
            <<body>>{children}<</body>>
        <</html>>
    );
}]], {
            title = i(1, "My App"),
            description = i(2, "App description"),
        })
    ),

    s({ trig = "nloading", name = "Next.js Loading", dscr = "Loading UI component" },
        fmta([[
// shown as fallback while the page's async data loads
export default function Loading() {
    return (
        <<div>>
            <finish>
        <</div>>
    );
}]], {
            finish = i(0, "Loading..."),
        })
    ),

    s({ trig = "nerror", name = "Next.js Error", dscr = "Error boundary component" },
        fmta([[
"use client";
// error boundaries must be Client Components

export default function Error({
    error,
    reset,
}: {
    error: Error & { digest?: string };
    reset: () =>> void; // call reset() to re-render and retry
}) {
    return (
        <<div>>
            <<h2>><msg><</h2>>
            <<button onClick={() =>> reset()}>><btn><</button>>
            <finish>
        <</div>>
    );
}]], {
            msg = i(1, "Something went wrong!"),
            btn = i(2, "Try again"),
            finish = i(0),
        })
    ),

    s({ trig = "nnotfound", name = "Next.js Not Found", dscr = "Custom not-found page" },
        fmta([[
import Link from "next/link";

export default function NotFound() {
    return (
        <<div>>
            <<h2>><title><</h2>>
            <<p>><msg><</p>>
            <<Link href="<href>">>Return Home<</Link>>
            <finish>
        <</div>>
    );
}]], {
            title = i(1, "Not Found"),
            msg = i(2, "Could not find requested resource."),
            href = i(3, "/"),
            finish = i(0),
        })
    ),

    s({ trig = "nmetadata", name = "Next.js generateMetadata", dscr = "Dynamic metadata generation for pages" },
        fmta([[
import type { Metadata } from "next";

type Props = {
    params: Promise<<{ <param>: string }>>;
};

// dynamic metadata: fetches data to build SEO tags per-page
export async function generateMetadata({ params }: Props): Promise<<Metadata>> {
    const { <param_r> } = await params;

    return {
        title: "<title>",
        description: "<description>",
        <finish>
    };
}]], {
            param = i(1, "id"),
            param_r = rep(1),
            title = i(2, ""),
            description = i(3, ""),
            finish = i(0),
        })
    ),

    s({ trig = "nstaticparams", name = "Next.js generateStaticParams", dscr = "Static params for dynamic routes" },
        fmta([[
// pre-render these params at build time (SSG)
export async function generateStaticParams() {
    <finish>
    return [{ <param>: "<value>" }];
}]], {
            param = i(1, "id"),
            value = i(2, "1"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  COMPONENTS                                                  ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "nclient", name = "Next.js Client Component", dscr = "Client component with useState" },
        fmta([[
"use client";
// required for hooks (useState, useEffect, etc.)

import { useState } from "react";

export default function <name>() {
    const [<state>, <setter>] = useState(<initial>);

    return (
        <<div>>
            <finish>
        <</div>>
    );
}]], {
            name = i(1, "MyComponent"),
            state = i(2, "count"),
            setter = f(to_setter, { 2 }),
            initial = i(3, "0"),
            finish = i(0),
        })
    ),

    s({ trig = "nprovider", name = "Next.js Context Provider", dscr = "Context provider with custom hook" },
        fmta([[
"use client";
// providers must be Client Components

import { createContext, useContext, useState, type ReactNode } from "react";

type <name>ContextType = {
    <type_body>
};

// null default forces consumers to be inside the Provider
const <r1>Context = createContext<<<r2>ContextType | null>>(null);

export function use<r3>() {
    const ctx = useContext(<r4>Context);
    // guard: ensures hook is used within Provider
    if (!ctx) throw new Error("use<r5> must be used within <r6>Provider");
    return ctx;
}

export function <r7>Provider({ children }: { children: ReactNode }) {
    <finish>
    return (
        <<<r8>Context.Provider value={<ctx_value>}>>
            {children}
        <</<r9>Context.Provider>>
    );
}]], {
            name = i(1, "Theme"),
            type_body = i(2, "value: string"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1),
            r5 = rep(1), r6 = rep(1), r7 = rep(1), r8 = rep(1), r9 = rep(1),
            ctx_value = i(3, "{ }"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  FORMS                                                       ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "nform", name = "Next.js Form", dscr = "Form with inline server action" },
        fmta([[
export default function <name>() {
    async function handleSubmit(formData: FormData) {
        "use server";
        // inline server action: this function runs on the server
        const <field> = formData.get("<field_r>") as string; // extract named field from form
        <body>
    }

    return (
        <<form action={handleSubmit}>>
            <<label htmlFor="<field_r2>">><label_text><</label>>
            <<input id="<field_r3>" name="<field_r4>" type="<type>" required />>
            <<button type="submit">><btn><</button>>
        <</form>>
    );
}]], {
            name = i(1, "MyForm"),
            field = i(2, "name"),
            field_r = rep(2), field_r2 = rep(2), field_r3 = rep(2), field_r4 = rep(2),
            body = i(0),
            label_text = i(3, "Name"),
            type = i(4, "text"),
            btn = i(5, "Submit"),
        })
    ),

    s({ trig = "nformclient", name = "Next.js Client Form", dscr = "Client form with useActionState" },
        fmta([[
"use client";
// client form: handles pending state and server action responses

import { useActionState } from "react";
import { <action> } from "<action_path>";

export default function <name>() {
    // state: server response, formAction: enhanced action, pending: loading flag
    const [state, formAction, pending] = useActionState(<action_r>, <initial_state>);

    return (
        <<form action={formAction}>>
            <<input name="<field>" type="<type>" required />>
            <<button type="submit" disabled={pending}>>
                {pending ? "Submitting..." : "<btn>"}
            <</button>>
            {state?.error && <<p>>{state.error}<</p>>}
        <</form>>
    );
}]], {
            action = i(1, "submitAction"),
            action_path = i(2, "./actions"),
            name = i(3, "MyForm"),
            action_r = rep(1),
            initial_state = i(4, "null"),
            field = i(5, "name"),
            type = i(6, "text"),
            btn = i(7, "Submit"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  DATA FETCHING                                               ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "nfetch", name = "Next.js Fetch Page", dscr = "Server component with data fetching" },
        fmta([[
async function <fetch_name>() {
    const res = await fetch("<url>", <cache>); // cache strategy: revalidate | no-store | force-cache
    if (!res.ok) throw new Error("Failed to fetch");
    return res.json();
}

// server components can be async and fetch data directly
export default async function <page_name>Page() {
    const <data> = await <fetch_r>();

    return (
        <<div>>
            <finish>
        <</div>>
    );
}]], {
            fetch_name = i(1, "getData"),
            url = i(2, "https://api.example.com/data"),
            cache = c(3, {
                t('{ next: { revalidate: 3600 } }'),
                t('{ cache: "no-store" }'),
                t('{ cache: "force-cache" }'),
            }),
            page_name = i(4, ""),
            data = i(5, "data"),
            fetch_r = rep(1),
            finish = i(0),
        })
    ),

    s({ trig = "nlist", name = "Next.js List Page", dscr = "Server component list with links" },
        fmta([[
import Link from "next/link";

type <name> = {
    id: string;
    <field>: string;
};

// data fetching function (runs on server)
async function get<plural>(): Promise<<<r1>[]>> {
    const res = await fetch("<url>");
    if (!res.ok) throw new Error("Failed to fetch");
    return res.json();
}

// server component: fetches data before rendering
export default async function Page() {
    const <camel_plural> = await get<plural_r>();

    return (
        <<div>>
            <<h1>><title><</h1>>
            <<ul>>
                {<cp_r>.map((<camel>) =>> (
                    <<li key={<c_r>.id}>>
                        <<Link href={`/<path>/${<c_r2>.id}`}>>{<c_r3>.<field_r>}<</Link>>
                    <</li>>
                ))}
            <</ul>>
            <finish>
        <</div>>
    );
}]], {
            name = i(1, "Item"),
            field = i(2, "name"),
            plural = f(to_pascal_plural, { 1 }),
            r1 = rep(1),
            url = i(3, "https://api.example.com/items"),
            camel_plural = f(to_camel_plural, { 1 }),
            plural_r = f(to_pascal_plural, { 1 }),
            title = i(4, "Items"),
            cp_r = f(to_camel_plural, { 1 }),
            camel = f(to_camel, { 1 }),
            c_r = f(to_camel, { 1 }), c_r2 = f(to_camel, { 1 }), c_r3 = f(to_camel, { 1 }),
            field_r = rep(2),
            path = f(to_kebab_plural, { 1 }),
            finish = i(0),
        })
    ),
}
