local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  FULL PAGE TEMPLATES                                        ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dtplbase", name = "Django Base Template", dscr = "Base HTML template with nav, messages, blocks" },
        fmta([[<<!DOCTYPE html>>
<<html lang="en">>
<<head>>
    <<meta charset="UTF-8">>
    <<meta name="viewport" content="width=device-width, initial-scale=1.0">>
    <<title>>{% block title %}<page_title>{% endblock %}<</title>>
    {# child templates can add stylesheets in extra_css block #}
    {% block extra_css %}{% endblock %}
<</head>>
<<body>>
    <<nav>>
        <<a href="{% url '<home_url>' %}">>Home<</a>>
    <</nav>>

    <<main>>
        {# django messages framework: displays success/error/info alerts #}
        {% if messages %}
        <<ul class="messages">>
            {% for message in messages %}
            <<li class="{{ message.tags }}">>{{ message }}<</li>>
            {% endfor %}
        <</ul>>
        {% endif %}

        {# child templates override this block with page content #}
        {% block content %}{% endblock %}
    <</main>>

    <<footer>>
        <finish>
    <</footer>>

    {# child templates can add scripts in extra_js block #}
    {% block extra_js %}{% endblock %}
<</body>>
<</html>>]], {
            page_title = i(1, "My Site"),
            home_url = i(2, "home"),
            finish = i(0),
        })
    ),

    s({ trig = "dtpllist", name = "Django List Template", dscr = "List view template with pagination" },
        fmta([[{% extends "<base>" %}

{% block title %}<title>{% endblock %}

{% block content %}
<<h1>><heading><</h1>>

{# loop through queryset; use "object_list" or the context_object_name from the view #}
{% for <item> in <items> %}
<<div>>
    <<a href="{% url '<url_name>-detail' <item_r>.pk %}">>
        {{ <item_r2>.<field> }}
    <</a>>
<</div>>
{# empty: shown when queryset has no items #}
{% empty %}
<<p>>No items found.<</p>>
{% endfor %}

{# pagination: page_obj is provided by ListView with paginate_by #}
{% if page_obj.has_other_pages %}
<<nav>>
    {% if page_obj.has_previous %}
    <<a href="?page={{ page_obj.previous_page_number }}">>Previous<</a>>
    {% endif %}
    <<span>>Page {{ page_obj.number }} of {{ page_obj.paginator.num_pages }}<</span>>
    {% if page_obj.has_next %}
    <<a href="?page={{ page_obj.next_page_number }}">>Next<</a>>
    {% endif %}
<</nav>>
{% endif %}
{% endblock %}]], {
            base = i(1, "base.html"),
            title = i(2, "Items"),
            heading = rep(2),
            item = i(3, "item"),
            items = i(4, "object_list"),
            url_name = i(5, "item"),
            item_r = rep(3), item_r2 = rep(3),
            field = i(6, "name"),
        })
    ),

    s({ trig = "dtpldetail", name = "Django Detail Template", dscr = "Detail view template with edit/delete links" },
        fmta([[{% extends "<base>" %}

{% block title %}{{ <object>.<title_field> }}{% endblock %}

{% block content %}
<<h1>>{{ <obj_r>.<title_r> }}<</h1>>

<<div>>
    <finish>
<</div>>

{# url tag generates URLs by name (defined in urls.py) #}
<<a href="{% url '<url_name>-list' %}">>Back to list<</a>>
<<a href="{% url '<url_name2>-update' <obj_r2>.pk %}">>Edit<</a>>
<<a href="{% url '<url_name3>-delete' <obj_r3>.pk %}">>Delete<</a>>
{% endblock %}]], {
            base = i(1, "base.html"),
            object = i(2, "object"),
            title_field = i(3, "name"),
            obj_r = rep(2), obj_r2 = rep(2), obj_r3 = rep(2),
            title_r = rep(3),
            finish = i(0),
            url_name = i(4, "item"), url_name2 = rep(4), url_name3 = rep(4),
        })
    ),

    s({ trig = "dtplform", name = "Django Form Template", dscr = "Form template with CSRF and submit" },
        fmta([[{% extends "<base>" %}

{% block title %}<title>{% endblock %}

{% block content %}
<<h1>><heading><</h1>>

<<form method="post">>
    {# csrf_token: required for all POST forms (prevents cross-site attacks) #}
    {% csrf_token %}
    {# renders all form fields wrapped in p tags; alternatives: as_div, as_table #}
    {{ form.as_p }}
    <<button type="submit">><btn_text><</button>>
<</form>>

<<a href="{% url '<cancel_url>' %}">>Cancel<</a>>
{% endblock %}]], {
            base = i(1, "base.html"),
            title = i(2, "Form"),
            heading = rep(2),
            btn_text = i(3, "Save"),
            cancel_url = i(4, "item-list"),
        })
    ),

    s({ trig = "dtpldelete", name = "Django Delete Template", dscr = "Delete confirmation template" },
        fmta([[{% extends "<base>" %}

{% block title %}Delete {{ <object>.<field> }}{% endblock %}

{% block content %}
<<h1>>Delete {{ <obj_r>.<field_r> }}?<</h1>>

<<p>>Are you sure you want to delete "{{ <obj_r2>.<field_r2> }}"?<</p>>

{# always use POST for destructive actions, never GET #}
<<form method="post">>
    {% csrf_token %}
    <<button type="submit">>Confirm Delete<</button>>
<</form>>

<<a href="{% url '<cancel_url>' %}">>Cancel<</a>>
{% endblock %}]], {
            base = i(1, "base.html"),
            object = i(2, "object"),
            field = i(3, "name"),
            obj_r = rep(2), obj_r2 = rep(2),
            field_r = rep(3), field_r2 = rep(3),
            cancel_url = i(4, "item-list"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  REUSABLE BLOCKS                                            ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dpagination", name = "Django Pagination", dscr = "Pagination navigation block" },
        fmta([[{% if page_obj.has_other_pages %}
<<nav class="pagination">>
    {% if page_obj.has_previous %}
    <<a href="?page={{ page_obj.previous_page_number }}">>Previous<</a>>
    {% endif %}
    <<span>>Page {{ page_obj.number }} of {{ page_obj.paginator.num_pages }}<</span>>
    {% if page_obj.has_next %}
    <<a href="?page={{ page_obj.next_page_number }}">>Next<</a>>
    {% endif %}
<</nav>>
{% endif %}
<finish>]], {
            finish = i(0),
        })
    ),

    s({ trig = "dmessages", name = "Django Messages", dscr = "Messages display block" },
        fmta([[{% if messages %}
<<ul class="messages">>
    {# tags include: debug, info, success, warning, error #}
    {% for message in messages %}
    <<li class="{{ message.tags }}">>
        {{ message }}
    <</li>>
    {% endfor %}
<</ul>>
{% endif %}
<finish>]], {
            finish = i(0),
        })
    ),

    s({ trig = "dfor", name = "Django For Loop", dscr = "For loop with empty clause" },
        fmta([[{% for <item> in <collection> %}
    <body>
{% empty %}
    <<p>><empty_msg><</p>>
{% endfor %}]], {
            item = i(1, "item"),
            collection = i(2, "items"),
            body = i(0),
            empty_msg = i(3, "No items found."),
        })
    ),

    s({ trig = "dblock", name = "Django Block", dscr = "Template block tag" },
        fmta([[{% block <name> %}
<content>
{% endblock %}]], {
            name = i(1, "content"),
            content = i(0),
        })
    ),
}
