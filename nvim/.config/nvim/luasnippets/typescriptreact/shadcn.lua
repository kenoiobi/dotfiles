local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  FORMS                                                       ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "shform", name = "shadcn Form", dscr = "Form with react-hook-form and zod validation" },
        fmta([[
"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { Button } from "@/components/ui/button";
import {
    Form,
    FormControl,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";

// 1. define validation schema
const formSchema = z.object({
    <schema_field>: <schema_val>,
});

// 2. infer TS type from schema
type FormValues = z.infer<<typeof formSchema>>;

export default function <name>() {
    const form = useForm<<FormValues>>({
        resolver: zodResolver(formSchema), // connects zod validation to react-hook-form
        defaultValues: { // must match schema shape
            <default_field>: "<default_value>",
        },
    });

    function onSubmit(values: FormValues) {
        <finish>
    }

    // Form component provides context to FormField children
    return (
        <<Form {...form}>>
            <<form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">>
                <<FormField
                    control={form.control}
                    name="<field_name>"
                    render={({ field }) =>> (
                        <<FormItem>>
                            <<FormLabel>><label><</FormLabel>>
                            <<FormControl>>
                                <<Input placeholder="<placeholder>" {...field} />>
                            <</FormControl>>
                            <<FormMessage />>
                        <</FormItem>>
                    )}
                />>
                <<Button type="submit">><btn><</Button>>
            <</form>>
        <</Form>>
    );
}]], {
            schema_field = i(1, "name"),
            schema_val = c(2, {
                t('z.string().min(1, "Required")'),
                t("z.string()"),
                t("z.number()"),
                t("z.boolean()"),
            }),
            name = i(3, "MyForm"),
            default_field = rep(1),
            default_value = i(4, ""),
            finish = i(0),
            field_name = rep(1),
            label = i(5, "Name"),
            placeholder = i(6, "Enter name"),
            btn = i(7, "Submit"),
        })
    ),

    s({ trig = "shformfield", name = "shadcn FormField", dscr = "Form field with label, input, and validation" },
        fmta([[
<<FormField
    control={form.control}
    name="<field_name>"
    render={({ field }) =>> (
        <<FormItem>>
            <<FormLabel>><label><</FormLabel>>
            <<FormControl>>
                <<Input placeholder="<placeholder>" {...field} />>
            <</FormControl>>
            <<FormMessage />>
        <</FormItem>>
    )}
/>>]], {
            field_name = i(1, "name"),
            label = i(2, "Name"),
            placeholder = i(3, "Enter value"),
        })
    ),

    s({ trig = "shformselect", name = "shadcn FormField Select", dscr = "Form field with select dropdown" },
        fmta([[
<<FormField
    control={form.control}
    name="<field_name>"
    render={({ field }) =>> (
        <<FormItem>>
            <<FormLabel>><label><</FormLabel>>
            <<Select onValueChange={field.onChange} defaultValue={field.value}>>
                <<FormControl>>
                    <<SelectTrigger>>
                        <<SelectValue placeholder="<placeholder>" />>
                    <</SelectTrigger>>
                <</FormControl>>
                <<SelectContent>>
                    <<SelectItem value="<val1>">><label1><</SelectItem>>
                    <<SelectItem value="<val2>">><label2><</SelectItem>>
                    <finish>
                <</SelectContent>>
            <</Select>>
            <<FormMessage />>
        <</FormItem>>
    )}
/>>]], {
            field_name = i(1, "status"),
            label = i(2, "Status"),
            placeholder = i(3, "Select an option"),
            val1 = i(4, "active"),
            label1 = i(5, "Active"),
            val2 = i(6, "inactive"),
            label2 = i(7, "Inactive"),
            finish = i(0),
        })
    ),

    s({ trig = "shlogin", name = "shadcn Login Page", dscr = "Login page with Card, email/password fields, zod validation" },
        fmta([[
"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import {
    Form,
    FormControl,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";

// 1. define validation schema
const loginSchema = z.object({
    email: z.string().email("Invalid email address"),
    password: z.string().min(<min_len>, "Password must be at least <min_len_r> characters"),
});

// 2. infer TypeScript type from schema
type LoginValues = z.infer<<typeof loginSchema>>;

export default function <name>() {
    const form = useForm<<LoginValues>>({
        resolver: zodResolver(loginSchema), // connects zod to react-hook-form
        defaultValues: { // must provide defaults for all fields
            email: "",
            password: "",
        },
    });

    // 3. handle submission — only called if validation passes
    async function onSubmit(values: LoginValues) {
        // values is fully typed and validated — call your auth API here
        <finish>
    }

    return (
        <<div className="flex min-h-screen items-center justify-center">>
            <<Card className="w-full max-w-md">>
                <<CardHeader>>
                    <<CardTitle>><title><</CardTitle>>
                    <<CardDescription>><description><</CardDescription>>
                <</CardHeader>>
                <<CardContent>>
                    {/* Form provider gives context to all FormField children */}
                    <<Form {...form}>>
                        {/* form.handleSubmit validates before calling onSubmit */}
                        <<form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">>
                            {/* each FormField connects a form control to validation */}
                            <<FormField
                                control={form.control}
                                name="email"
                                render={({ field }) =>> (
                                    <<FormItem>>
                                        <<FormLabel>>Email<</FormLabel>>
                                        <<FormControl>>
                                            {/* {...field} binds value, onChange, onBlur, ref */}
                                            <<Input placeholder="you@example.com" type="email" {...field} />>
                                        <</FormControl>>
                                        <<FormMessage />> {/* shows validation error for this field */}
                                    <</FormItem>>
                                )}
                            />>
                            <<FormField
                                control={form.control}
                                name="password"
                                render={({ field }) =>> (
                                    <<FormItem>>
                                        <<FormLabel>>Password<</FormLabel>>
                                        <<FormControl>>
                                            <<Input placeholder="••••••••" type="password" {...field} />>
                                        <</FormControl>>
                                        <<FormMessage />>
                                    <</FormItem>>
                                )}
                            />>
                            {/* disabled while submitting to prevent double-clicks */}
                            <<Button type="submit" className="w-full" disabled={form.formState.isSubmitting}>>
                                {form.formState.isSubmitting ? "Signing in..." : "<btn>"}
                            <</Button>>
                        <</form>>
                    <</Form>>
                <</CardContent>>
            <</Card>>
        <</div>>
    );
}]], {
            min_len = i(1, "8"),
            min_len_r = rep(1),
            name = i(2, "LoginForm"),
            finish = i(0),
            title = i(3, "Sign in"),
            description = i(4, "Enter your credentials to continue"),
            btn = i(5, "Sign in"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  OVERLAYS                                                    ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "shdialog", name = "shadcn Dialog", dscr = "Dialog with trigger, header, and footer" },
        fmta([[
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";

<<Dialog>>
    <<DialogTrigger asChild>>
        <<Button variant="outline">><trigger><</Button>>
    <</DialogTrigger>>
    <<DialogContent>>
        <<DialogHeader>>
            <<DialogTitle>><title><</DialogTitle>>
            <<DialogDescription>><description><</DialogDescription>>
        <</DialogHeader>>
        <finish>
        <<DialogFooter>>
            <<Button type="submit">><btn><</Button>>
        <</DialogFooter>>
    <</DialogContent>>
<</Dialog>>]], {
            trigger = i(1, "Open"),
            title = i(2, "Title"),
            description = i(3, "Description"),
            finish = i(0),
            btn = i(4, "Save"),
        })
    ),

    s({ trig = "shalertdialog", name = "shadcn AlertDialog", dscr = "Confirmation dialog with cancel and action" },
        fmta([[
import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
} from "@/components/ui/alert-dialog";

<<AlertDialog>>
    <<AlertDialogTrigger>><trigger><</AlertDialogTrigger>>
    <<AlertDialogContent>>
        <<AlertDialogHeader>>
            <<AlertDialogTitle>><title><</AlertDialogTitle>>
            <<AlertDialogDescription>>
                <description>
            <</AlertDialogDescription>>
        <</AlertDialogHeader>>
        <<AlertDialogFooter>>
            <<AlertDialogCancel>><cancel><</AlertDialogCancel>>
            <<AlertDialogAction>><action><</AlertDialogAction>>
        <</AlertDialogFooter>>
    <</AlertDialogContent>>
<</AlertDialog>>]], {
            trigger = i(1, "Delete"),
            title = i(2, "Are you sure?"),
            description = i(3, "This action cannot be undone."),
            cancel = i(4, "Cancel"),
            action = i(5, "Continue"),
        })
    ),

    s({ trig = "shsheet", name = "shadcn Sheet", dscr = "Slide-over panel with trigger and header" },
        fmta([[
import {
    Sheet,
    SheetContent,
    SheetDescription,
    SheetHeader,
    SheetTitle,
    SheetTrigger,
} from "@/components/ui/sheet";
import { Button } from "@/components/ui/button";

<<Sheet>>
    <<SheetTrigger asChild>>
        <<Button variant="outline">><trigger><</Button>>
    <</SheetTrigger>>
    <<SheetContent>>
        <<SheetHeader>>
            <<SheetTitle>><title><</SheetTitle>>
            <<SheetDescription>><description><</SheetDescription>>
        <</SheetHeader>>
        <finish>
    <</SheetContent>>
<</Sheet>>]], {
            trigger = i(1, "Open"),
            title = i(2, "Title"),
            description = i(3, "Description"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  DATA DISPLAY                                                ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "shcard", name = "shadcn Card", dscr = "Card with header, content, and footer" },
        fmta([[
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from "@/components/ui/card";

<<Card>>
    <<CardHeader>>
        <<CardTitle>><title><</CardTitle>>
        <<CardDescription>><description><</CardDescription>>
    <</CardHeader>>
    <<CardContent>>
        <finish>
    <</CardContent>>
    <<CardFooter>>
        <footer>
    <</CardFooter>>
<</Card>>]], {
            title = i(1, "Title"),
            description = i(2, "Description"),
            finish = i(0),
            footer = i(3, ""),
        })
    ),

    s({ trig = "shtable", name = "shadcn Table", dscr = "Table with header and mapped rows" },
        fmta([[
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";

<<Table>>
    <<TableHeader>>
        <<TableRow>>
            <<TableHead>><head1><</TableHead>>
            <<TableHead>><head2><</TableHead>>
        <</TableRow>>
    <</TableHeader>>
    <<TableBody>>
        {<items>.map((<item>) =>> (
            <<TableRow key={<item_r>.id}>>
                <<TableCell>>{<item_r2>.<cell1>}<</TableCell>>
                <<TableCell>>{<item_r3>.<cell2>}<</TableCell>>
            <</TableRow>>
        ))}
    <</TableBody>>
<</Table>>]], {
            head1 = i(1, "Name"),
            head2 = i(2, "Status"),
            items = i(3, "items"),
            item = i(4, "item"),
            item_r = rep(4), item_r2 = rep(4), item_r3 = rep(4),
            cell1 = i(5, "name"),
            cell2 = i(6, "status"),
        })
    ),

    s({ trig = "shcolumns", name = "shadcn Data Table Columns", dscr = "Column definitions for TanStack data table" },
        fmta([[
"use client";

import { ColumnDef } from "@tanstack/react-table";

export type <name> = {
    id: string;
    <field1>: <type1>;
    <field2>: <type2>;
};

// column definitions for TanStack Table (used by DataTable component)
export const columns: ColumnDef<<<r1>>>[] = [
    {
        accessorKey: "<key1>", // maps to a property on the data object
        header: "<header1>", // column header text
    },
    {
        accessorKey: "<key2>",
        header: "<header2>",
    },
    <finish>
];]], {
            name = i(1, "Item"),
            field1 = i(2, "name"),
            type1 = i(3, "string"),
            field2 = i(4, "status"),
            type2 = i(5, "string"),
            r1 = rep(1),
            key1 = rep(2),
            header1 = i(6, "Name"),
            key2 = rep(4),
            header2 = i(7, "Status"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  NAVIGATION                                                  ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "shdropdown", name = "shadcn DropdownMenu", dscr = "Dropdown menu with trigger and items" },
        fmta([[
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";

<<DropdownMenu>>
    <<DropdownMenuTrigger asChild>>
        <<Button variant="ghost">><trigger><</Button>>
    <</DropdownMenuTrigger>>
    <<DropdownMenuContent align="end">>
        <<DropdownMenuLabel>><menu_label><</DropdownMenuLabel>>
        <<DropdownMenuSeparator />>
        <<DropdownMenuItem>><item1><</DropdownMenuItem>>
        <<DropdownMenuItem>><item2><</DropdownMenuItem>>
        <finish>
    <</DropdownMenuContent>>
<</DropdownMenu>>]], {
            trigger = i(1, "Actions"),
            menu_label = i(2, "Actions"),
            item1 = i(3, "Edit"),
            item2 = i(4, "Delete"),
            finish = i(0),
        })
    ),

    s({ trig = "shtabs", name = "shadcn Tabs", dscr = "Tabs with content panels" },
        fmta([[
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

<<Tabs defaultValue="<default>">>
    <<TabsList>>
        <<TabsTrigger value="<val1>">><label1><</TabsTrigger>>
        <<TabsTrigger value="<val2>">><label2><</TabsTrigger>>
    <</TabsList>>
    <<TabsContent value="<val1_r>">>
        <content1>
    <</TabsContent>>
    <<TabsContent value="<val2_r>">>
        <finish>
    <</TabsContent>>
<</Tabs>>]], {
            default = rep(1),
            val1 = i(1, "tab1"),
            label1 = i(2, "Tab 1"),
            val2 = i(3, "tab2"),
            label2 = i(4, "Tab 2"),
            val1_r = rep(1),
            val2_r = rep(3),
            content1 = i(5, ""),
            finish = i(0),
        })
    ),

    s({ trig = "shcommand", name = "shadcn Command", dscr = "Command palette with search and items" },
        fmta([[
import {
    Command,
    CommandEmpty,
    CommandGroup,
    CommandInput,
    CommandItem,
    CommandList,
} from "@/components/ui/command";

<<Command>>
    <<CommandInput placeholder="<search_placeholder>" />>
    <<CommandList>>
        <<CommandEmpty>><empty_msg><</CommandEmpty>>
        <<CommandGroup heading="<heading>">>
            <<CommandItem>><item1><</CommandItem>>
            <<CommandItem>><item2><</CommandItem>>
            <finish>
        <</CommandGroup>>
    <</CommandList>>
<</Command>>]], {
            search_placeholder = i(1, "Search..."),
            empty_msg = i(2, "No results found."),
            heading = i(3, "Items"),
            item1 = i(4, "Item 1"),
            item2 = i(5, "Item 2"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  FEEDBACK                                                    ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "shtoast", name = "shadcn Toast", dscr = "Toast notification with useToast" },
        fmta([[
const { toast } = useToast(); // must be inside a component wrapped by Toaster

toast({
    title: "<title>",
    description: "<description>",
    <finish>
});]], {
            title = i(1, "Success"),
            description = i(2, "Operation completed."),
            finish = i(0),
        })
    ),
}
