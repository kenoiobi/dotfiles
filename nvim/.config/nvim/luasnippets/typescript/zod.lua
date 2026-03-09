local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  SCHEMAS                                                     ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "zenum", name = "Zod Enum", dscr = "Enum schema with inferred type" },
        fmta([[
import { z } from "zod";

export const <name>Schema = z.enum([<values>]); // string union validated at runtime

export type <name_r> = z.infer<<typeof <name_r2>Schema>>; // infer TS type: "active" | "inactive" | ...]], {
            name = i(1, "status"),
            values = i(2, '"active", "inactive", "archived"'),
            name_r = rep(1), name_r2 = rep(1),
        })
    ),

    s({ trig = "zrefine", name = "Zod Refine", dscr = "Object schema with cross-field refinement" },
        fmta([[
import { z } from "zod";

export const <name>Schema = z.object({
    <field1>: <val1>,
    <field2>: <val2>,
    <field3>: <val3>,
})
// .refine() adds custom cross-field validation
.refine((data) =>> <condition>, {
    message: "<message>",
    path: ["<refine_path>"], // field to attach the error to
});

export type <name_r> = z.infer<<typeof <name_r2>Schema>>;]], {
            name = i(1, "register"),
            field1 = i(2, "email"),
            val1 = i(3, 'z.string().email("Invalid email")'),
            field2 = i(4, "password"),
            val2 = i(5, 'z.string().min(8, "Minimum 8 characters")'),
            field3 = i(6, "confirmPassword"),
            val3 = i(7, "z.string()"),
            condition = i(8, "data.password === data.confirmPassword"),
            message = i(9, "Passwords don't match"),
            refine_path = rep(6),
            name_r = rep(1), name_r2 = rep(1),
        })
    ),

    s({ trig = "zcoerce", name = "Zod Coerce", dscr = "Schema with coerced types for form/query data" },
        fmta([[
import { z } from "zod";

export const <name>Schema = z.object({
    // z.coerce auto-converts strings from forms/URLs to the target type
    <field1>: z.coerce.<type1>,
    <field2>: z.coerce.<type2>,
    <field3>: <val3>,
    <finish>
});

export type <name_r> = z.infer<<typeof <name_r2>Schema>>;]], {
            name = i(1, "filter"),
            field1 = i(2, "page"),
            type1 = i(3, "number().int().positive().default(1)"),
            field2 = i(4, "limit"),
            type2 = i(5, "number().int().positive().max(100).default(10)"),
            field3 = i(6, "search"),
            val3 = i(7, "z.string().optional()"),
            finish = i(0),
            name_r = rep(1), name_r2 = rep(1),
        })
    ),

    s({ trig = "zextend", name = "Zod Extend", dscr = "Base schema with extend and partial variants" },
        fmta([[
import { z } from "zod";

const <base>Schema = z.object({
    <field1>: <val1>,
    <field2>: <val2>,
});

// .extend() adds fields to the base schema
export const <create>Schema = <base_r>Schema.extend({
    <extra_field>: <extra_val>,
    <finish>
});

export const <update>Schema = <base_r2>Schema.partial(); // .partial() makes all fields optional

export type <create_r> = z.infer<<typeof <create_r2>Schema>>;
export type <update_r> = z.infer<<typeof <update_r2>Schema>>;]], {
            base = i(1, "base"),
            field1 = i(2, "name"),
            val1 = i(3, 'z.string().min(1, "Required")'),
            field2 = i(4, "email"),
            val2 = i(5, 'z.string().email("Invalid email")'),
            create = i(6, "create"),
            base_r = rep(1), base_r2 = rep(1),
            extra_field = i(7, "password"),
            extra_val = i(8, 'z.string().min(8, "Minimum 8 characters")'),
            finish = i(0),
            update = i(9, "update"),
            create_r = rep(6), create_r2 = rep(6),
            update_r = rep(9), update_r2 = rep(9),
        })
    ),
}
