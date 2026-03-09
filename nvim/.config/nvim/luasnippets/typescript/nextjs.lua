local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  ROUTE HANDLERS                                              ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "nroute", name = "Next.js Route Handler", dscr = "GET and POST route handlers" },
        fmta([[
import { NextRequest, NextResponse } from "next/server";

// export a named function for each HTTP method you want to handle
export async function GET() {
    <get_body>
    return NextResponse.json({ <get_data> });
}

export async function POST(request: NextRequest) {
    const body = await request.json(); // parse JSON request body
    <finish>
    return NextResponse.json({ <post_data> }, { status: 201 }); // 201 Created
}]], {
            get_body = i(1, ""),
            get_data = i(2, "data: []"),
            finish = i(0),
            post_data = i(3, "data: body"),
        })
    ),

    s({ trig = "nrouteparams", name = "Next.js Route with Params", dscr = "Route handler with dynamic params" },
        fmta([[
import { NextRequest, NextResponse } from "next/server";

// params are async in Next.js 15+
type Params = {
    params: Promise<<{ <param>: string }>>;
};

export async function GET(request: NextRequest, { params }: Params) {
    const { <param_r> } = await params; // extract dynamic segment from URL
    <get_body>
    return NextResponse.json({ <get_data> });
}

export async function PUT(request: NextRequest, { params }: Params) {
    const { <param_r2> } = await params;
    const body = await request.json();
    <put_body>
    return NextResponse.json({ <put_data> });
}

export async function DELETE(request: NextRequest, { params }: Params) {
    const { <param_r3> } = await params;
    <finish>
    return new Response(null, { status: 204 }); // 204 No Content
}]], {
            param = i(1, "id"),
            param_r = rep(1), param_r2 = rep(1), param_r3 = rep(1),
            get_body = i(2, ""),
            get_data = i(3, "data: {}"),
            put_body = i(4, ""),
            put_data = i(5, "data: body"),
            finish = i(0),
        })
    ),

    s({ trig = "ncrudapi", name = "Next.js CRUD API", dscr = "Full CRUD route handlers for collection and item endpoints" },
        fmta([[
import { NextRequest, NextResponse } from "next/server";

// --- app/<path>/route.ts ---

export async function GET() {
    <list_body>
    return NextResponse.json({ <list_data> });
}

export async function POST(request: NextRequest) {
    const body = await request.json();
    <create_body>
    return NextResponse.json({ <create_data> }, { status: 201 }); // 201 Created
}

// --- app/<path_r>/[<param>]/route.ts ---

type Params = {
    params: Promise<<{ <param_r>: string }>>;
};

export async function GET(request: NextRequest, { params }: Params) {
    const { <param_r2> } = await params;
    <detail_body>
    return NextResponse.json({ <detail_data> });
}

export async function PUT(request: NextRequest, { params }: Params) {
    const { <param_r3> } = await params;
    const body = await request.json();
    <update_body>
    return NextResponse.json({ <update_data> });
}

export async function DELETE(request: NextRequest, { params }: Params) {
    const { <param_r4> } = await params;
    <finish>
    return new Response(null, { status: 204 }); // 204 No Content
}]], {
            path = i(1, "api/items"),
            list_body = i(2, ""),
            list_data = i(3, "data: []"),
            create_body = i(4, ""),
            create_data = i(5, "data: body"),
            path_r = rep(1),
            param = i(6, "id"),
            param_r = rep(6), param_r2 = rep(6), param_r3 = rep(6), param_r4 = rep(6),
            detail_body = i(7, ""),
            detail_data = i(8, "data: {}"),
            update_body = i(9, ""),
            update_data = i(10, "data: body"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  SERVER ACTIONS                                              ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "naction", name = "Next.js Server Action", dscr = "Server action with form data" },
        fmta([[
"use server";
// marks all exports in this file as Server Actions

import { revalidatePath } from "next/cache";

export async function <name>(formData: FormData) {
    const <field> = formData.get("<field_r>") as string;
    <finish>
    revalidatePath("<path>"); // purge cached page data
}]], {
            name = i(1, "createItem"),
            field = i(2, "name"),
            field_r = rep(2),
            finish = i(0),
            path = i(3, "/"),
        })
    ),

    s({ trig = "nactioncrud", name = "Next.js CRUD Actions", dscr = "Create, update, and delete server actions" },
        fmta([[
"use server";
// all exports are Server Actions (run on server only)

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

export async function create<name>(formData: FormData) {
    const <field> = formData.get("<field_r>") as string;
    <create_body>
    revalidatePath("<path>"); // purge cached data for this path
    redirect("<path_r>"); // navigate after mutation
}

export async function update<r1>(id: string, formData: FormData) {
    const <field_r2> = formData.get("<field_r3>") as string;
    <update_body>
    revalidatePath("<path_r2>");
}

export async function delete<r2>(id: string) {
    <finish>
    revalidatePath("<path_r3>");
    redirect("<path_r4>");
}]], {
            name = i(1, "Item"),
            field = i(2, "name"),
            field_r = rep(2), field_r2 = rep(2), field_r3 = rep(2),
            create_body = i(3, ""),
            path = i(4, "/items"),
            path_r = rep(4), path_r2 = rep(4), path_r3 = rep(4), path_r4 = rep(4),
            r1 = rep(1), r2 = rep(1),
            update_body = i(5, ""),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  MIDDLEWARE & CONFIG                                         ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "nmiddleware", name = "Next.js Middleware", dscr = "Middleware with matcher config" },
        fmta([[
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

// runs before every matched request
export function middleware(request: NextRequest) {
    <finish>
    return NextResponse.next(); // continue to the matched route
}

export const config = {
    matcher: "<matcher>", // regex to control which routes trigger this middleware
};]], {
            finish = i(0),
            matcher = i(1, "/((?!api|_next/static|_next/image|favicon.ico).*)"),
        })
    ),

    s({ trig = "nschema", name = "Zod Schema", dscr = "Zod validation schema with inferred type" },
        fmta([[
import { z } from "zod";

// define validation rules with zod
export const <name>Schema = z.object({
    <field1>: <val1>,
    <field2>: <val2>,
    <finish>
});

export type <name_r> = z.infer<<typeof <name_r2>Schema>>; // auto-infer TypeScript type from schema]], {
            name = i(1, "item"),
            field1 = i(2, "name"),
            val1 = c(3, {
                t('z.string().min(1, "Required")'),
                t("z.string()"),
                t("z.number()"),
                t("z.boolean()"),
            }),
            field2 = i(4, "email"),
            val2 = c(5, {
                t('z.string().email("Invalid email")'),
                t("z.string()"),
                t("z.number()"),
                t("z.boolean()"),
            }),
            finish = i(0),
            name_r = rep(1), name_r2 = rep(1),
        })
    ),

    s({ trig = "nnextconfig", name = "Next.js Config", dscr = "next.config.ts configuration" },
        fmta([[
import type { NextConfig } from "next";

// see: https://nextjs.org/docs/app/api-reference/config/next-config-js
const nextConfig: NextConfig = {
    <finish>
};

export default nextConfig;]], {
            finish = i(0),
        })
    ),
}
