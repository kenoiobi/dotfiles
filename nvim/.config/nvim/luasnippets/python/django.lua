local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local function snake_case(args)
    local name = args[1][1]
    if not name or name == "" then return "model" end
    return name
        :gsub("(%u+)(%u%l)", "%1_%2")
        :gsub("(%l)(%u)", "%1_%2")
        :lower()
end

local function snake_case_plural(args)
    local name = snake_case(args)
    if name:sub(-1) == "y" and not name:sub(-2, -2):match("[aeiou]") then
        return name:sub(1, -2) .. "ies"
    elseif name:sub(-1) == "s" or name:sub(-2) == "sh" or name:sub(-2) == "ch"
        or name:sub(-1) == "x" or name:sub(-1) == "z" then
        return name .. "es"
    else
        return name .. "s"
    end
end

return {

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  MODELS                                                     ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dmodel", name = "Django Model", dscr = "Model with timestamps, Meta, and __str__" },
        fmta([[
from django.db import models


class <model>(models.Model):
    <field_name> = models.<field_type>(<field_args>)
    created_at = models.DateTimeField(auto_now_add=True)  # set once on creation
    updated_at = models.DateTimeField(auto_now=True)  # updated on every save

    class Meta:
        ordering = ["-created_at"]  # newest first by default
        verbose_name = "<verbose>"  # singular name shown in admin
        verbose_name_plural = "<verbose_plural>"

    def __str__(self):  # displayed in admin, shell, logs
        return self.<str_field>
<finish>]], {
            model = i(1, "ModelName"),
            field_name = i(2, "name"),
            field_type = c(3, {
                t("CharField"), t("TextField"), t("SlugField"),
                t("IntegerField"), t("BooleanField"),
            }),
            field_args = i(4, "max_length=255"),
            verbose = f(snake_case, { 1 }),
            verbose_plural = f(snake_case_plural, { 1 }),
            str_field = rep(2),
            finish = i(0),
        })
    ),

    s({ trig = "dmodelfull", name = "Django Full Model", dscr = "Complete model with Meta, __str__, get_absolute_url" },
        fmta([[
from django.db import models
from django.urls import reverse


class <model>(models.Model):
    <name_field> = models.CharField(max_length=255)
    <desc_field> = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)  # soft-delete pattern
    created_at = models.DateTimeField(auto_now_add=True)  # set once on creation
    updated_at = models.DateTimeField(auto_now=True)  # updated on every save

    class Meta:
        ordering = ["-created_at"]  # newest first by default
        verbose_name = "<verbose>"  # singular name shown in admin
        verbose_name_plural = "<verbose_plural>"

    def __str__(self):  # displayed in admin, shell, logs
        return self.<str_field>

    def get_absolute_url(self):  # used by redirect() and admin "View on site"
        return reverse("<url_name>-detail", kwargs={"pk": self.pk})
<finish>]], {
            model = i(1, "ModelName"),
            name_field = i(2, "name"),
            desc_field = i(3, "description"),
            verbose = f(snake_case, { 1 }),
            verbose_plural = f(snake_case_plural, { 1 }),
            str_field = rep(2),
            url_name = f(snake_case, { 1 }),
            finish = i(0),
        })
    ),

    s({ trig = "dabstract", name = "Django Abstract Model", dscr = "Abstract base model" },
        fmta([[
from django.db import models


class <model>(models.Model):
    <field_name> = models.<field_type>(<field_args>)

    class Meta:
        abstract = True  # no DB table, fields inherited by child models
<finish>]], {
            model = i(1, "BaseModel"),
            field_name = i(2, "created_at"),
            field_type = c(3, { t("DateTimeField"), t("CharField"), t("BooleanField") }),
            field_args = i(4, "auto_now_add=True"),
            finish = i(0),
        })
    ),

    s({ trig = "dfk", name = "ForeignKey", dscr = "ForeignKey field" },
        fmta([[# on_delete: what happens when parent is deleted; related_name: reverse accessor
<field> = models.ForeignKey(<related>, on_delete=models.<on_delete>, related_name="<related_name>")]], {
            field = i(1, "author"),
            related = i(2, "User"),
            on_delete = c(3, { t("CASCADE"), t("SET_NULL"), t("PROTECT"), t("SET_DEFAULT"), t("DO_NOTHING") }),
            related_name = i(4, "posts"),
        })
    ),

    s({ trig = "dm2m", name = "ManyToManyField", dscr = "ManyToManyField" },
        fmta([[# blank=True: optional in forms; M2M is always nullable in DB
<field> = models.ManyToManyField(<related>, related_name="<related_name>", blank=True)]], {
            field = i(1, "tags"),
            related = i(2, "Tag"),
            related_name = i(3, "posts"),
        })
    ),

    s({ trig = "dchoices", name = "Django TextChoices", dscr = "Enum with TextChoices and CharField" },
        fmta([[
class <enum_name>(models.TextChoices):  # enum for limited choices
    <val1> = "<key1>", "<label1>"  # CONSTANT = "db_value", "Display Label"
    <val2> = "<key2>", "<label2>"
    <val3> = "<key3>", "<label3>"

<field> = models.CharField(
    max_length=<max_len>,
    choices=<enum_ref>.choices,  # populates dropdown options
    default=<enum_ref2>.<default>,  # fallback value
)]], {
            enum_name = i(1, "Status"),
            val1 = i(2, "DRAFT"), key1 = i(3, "draft"), label1 = i(4, "Draft"),
            val2 = i(5, "PUBLISHED"), key2 = i(6, "published"), label2 = i(7, "Published"),
            val3 = i(8, "ARCHIVED"), key3 = i(9, "archived"), label3 = i(10, "Archived"),
            field = i(11, "status"),
            max_len = i(12, "20"),
            enum_ref = rep(1), enum_ref2 = rep(1),
            default = rep(2),
        })
    ),

    s({ trig = "dmanager", name = "Django Manager", dscr = "Custom QuerySet + Manager" },
        fmta([[
class <name>QuerySet(models.QuerySet):  # chainable filter methods
    def <method1>(self):
        return self.filter(<filter1>)

    def <method2>(self):
        return self.filter(<filter2>)


class <name_r>Manager(models.Manager):  # access via Model.objects
    def get_queryset(self):  # base queryset for all queries
        return <name_r2>QuerySet(self.model, using=self._db)

    def <method1_r>(self):
        return self.get_queryset().<method1_r2>()]], {
            name = i(1, "Custom"),
            method1 = i(2, "active"),
            filter1 = i(3, "is_active=True"),
            method2 = i(4, "recent"),
            filter2 = i(5, 'created_at__gte=timezone.now() - timedelta(days=7)'),
            name_r = rep(1), name_r2 = rep(1),
            method1_r = rep(2), method1_r2 = rep(2),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  CLASS-BASED VIEWS                                          ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dlistview", name = "Django ListView", dscr = "Class-based ListView" },
        fmta([[
from django.views.generic import ListView
from .models import <model>


class <r1>ListView(ListView):
    model = <r2>
    template_name = "<app>/<tpl>_list.html"  # path to HTML template
    context_object_name = "<ctx>"  # variable name in template (default: object_list)
    paginate_by = <paginate>  # items per page, enables pagination
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            app = i(2, "app"),
            tpl = f(snake_case, { 1 }),
            ctx = f(snake_case_plural, { 1 }),
            paginate = i(3, "10"),
            finish = i(0),
        })
    ),

    s({ trig = "ddetailview", name = "Django DetailView", dscr = "Class-based DetailView" },
        fmta([[
from django.views.generic import DetailView
from .models import <model>


class <r1>DetailView(DetailView):
    model = <r2>
    template_name = "<app>/<tpl>_detail.html"
    context_object_name = "<ctx>"  # variable name in template (default: object)
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            app = i(2, "app"),
            tpl = f(snake_case, { 1 }),
            ctx = f(snake_case, { 1 }),
            finish = i(0),
        })
    ),

    s({ trig = "dcreateview", name = "Django CreateView", dscr = "Class-based CreateView" },
        fmta([[
from django.views.generic import CreateView
from django.urls import reverse_lazy
from .models import <model>


class <r1>CreateView(CreateView):
    model = <r2>
    fields = [<fields>]  # model fields to include in the form
    template_name = "<app>/<tpl>_form.html"
    success_url = reverse_lazy("<url_name>-list")  # redirect after successful creation
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            fields = i(2, '"name"'),
            app = i(3, "app"),
            tpl = f(snake_case, { 1 }),
            url_name = f(snake_case, { 1 }),
            finish = i(0),
        })
    ),

    s({ trig = "dupdateview", name = "Django UpdateView", dscr = "Class-based UpdateView" },
        fmta([[
from django.views.generic import UpdateView
from django.urls import reverse_lazy
from .models import <model>


class <r1>UpdateView(UpdateView):
    model = <r2>
    fields = [<fields>]  # model fields editable in the form
    template_name = "<app>/<tpl>_form.html"
    success_url = reverse_lazy("<url_name>-list")  # redirect after successful update
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            fields = i(2, '"name"'),
            app = i(3, "app"),
            tpl = f(snake_case, { 1 }),
            url_name = f(snake_case, { 1 }),
            finish = i(0),
        })
    ),

    s({ trig = "ddeleteview", name = "Django DeleteView", dscr = "Class-based DeleteView" },
        fmta([[
from django.views.generic import DeleteView
from django.urls import reverse_lazy
from .models import <model>


class <r1>DeleteView(DeleteView):
    model = <r2>
    template_name = "<app>/<tpl>_confirm_delete.html"
    success_url = reverse_lazy("<url_name>-list")  # redirect after deletion
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            app = i(2, "app"),
            tpl = f(snake_case, { 1 }),
            url_name = f(snake_case, { 1 }),
            finish = i(0),
        })
    ),

    s({ trig = "dcrudviews", name = "Django CRUD CBVs", dscr = "All 5 class-based CRUD views" },
        fmta([[
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from .models import <model>


class <r1>ListView(ListView):
    model = <r2>
    template_name = "<app>/<sn1>_list.html"
    context_object_name = "<snp1>"  # template variable for the list
    paginate_by = <paginate>  # items per page


class <r3>DetailView(DetailView):
    model = <r4>
    template_name = "<app2>/<sn2>_detail.html"
    context_object_name = "<sn3>"


class <r5>CreateView(CreateView):
    model = <r6>
    fields = [<fields>]  # model fields for the form
    template_name = "<app3>/<sn4>_form.html"
    success_url = reverse_lazy("<sn5>-list")  # redirect after success


class <r7>UpdateView(UpdateView):
    model = <r8>
    fields = [<fields2>]
    template_name = "<app4>/<sn6>_form.html"
    success_url = reverse_lazy("<sn7>-list")


class <r9>DeleteView(DeleteView):
    model = <r10>
    template_name = "<app5>/<sn8>_confirm_delete.html"
    success_url = reverse_lazy("<sn9>-list")
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1), r5 = rep(1),
            r6 = rep(1), r7 = rep(1), r8 = rep(1), r9 = rep(1), r10 = rep(1),
            app = i(2, "app"), app2 = rep(2), app3 = rep(2), app4 = rep(2), app5 = rep(2),
            fields = i(3, '"name"'), fields2 = rep(3),
            paginate = i(4, "10"),
            sn1 = f(snake_case, { 1 }), sn2 = f(snake_case, { 1 }), sn3 = f(snake_case, { 1 }),
            sn4 = f(snake_case, { 1 }), sn5 = f(snake_case, { 1 }), sn6 = f(snake_case, { 1 }),
            sn7 = f(snake_case, { 1 }), sn8 = f(snake_case, { 1 }), sn9 = f(snake_case, { 1 }),
            snp1 = f(snake_case_plural, { 1 }),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  FUNCTION-BASED VIEWS                                       ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dcrudfbv", name = "Django CRUD FBVs", dscr = "All CRUD function-based views" },
        fmta([[
from django.shortcuts import render, get_object_or_404, redirect
from django.core.paginator import Paginator
from .models import <model>
from .forms import <r1>Form


def <sn1>_list(request):
    queryset = <r2>.objects.all()
    paginator = Paginator(queryset, <per_page>)  # splits queryset into pages
    page = paginator.get_page(request.GET.get("page"))  # current page from ?page= param
    return render(request, "<app>/<sn2>_list.html", {"page_obj": page, "<snp1>": page.object_list})


def <sn3>_detail(request, pk):
    obj = get_object_or_404(<r3>, pk=pk)  # raises 404 if not found
    return render(request, "<app2>/<sn4>_detail.html", {"<sn5>": obj})


def <sn6>_create(request):
    if request.method == "POST":  # form was submitted
        form = <r4>Form(request.POST)
        if form.is_valid():  # passes all validation rules
            obj = form.save()  # saves to DB, returns instance
            return redirect("<sn7>-detail", pk=obj.pk)
    else:
        form = <r5>Form()  # empty form for GET request
    return render(request, "<app3>/<sn8>_form.html", {"form": form})


def <sn9>_update(request, pk):
    obj = get_object_or_404(<r6>, pk=pk)
    if request.method == "POST":
        form = <r7>Form(request.POST, instance=obj)  # bind POST data to existing object
        if form.is_valid():
            form.save()
            return redirect("<sn10>-detail", pk=obj.pk)
    else:
        form = <r8>Form(instance=obj)
    return render(request, "<app4>/<sn11>_form.html", {"form": form, "<sn12>": obj})


def <sn13>_delete(request, pk):
    obj = get_object_or_404(<r9>, pk=pk)
    if request.method == "POST":  # confirmation submitted
        obj.delete()  # removes from database
        return redirect("<sn14>-list")
    return render(request, "<app5>/<sn15>_confirm_delete.html", {"<sn16>": obj})
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1), r5 = rep(1),
            r6 = rep(1), r7 = rep(1), r8 = rep(1), r9 = rep(1),
            app = i(2, "app"), app2 = rep(2), app3 = rep(2), app4 = rep(2), app5 = rep(2),
            per_page = i(3, "10"),
            sn1 = f(snake_case, { 1 }), sn2 = f(snake_case, { 1 }), sn3 = f(snake_case, { 1 }),
            sn4 = f(snake_case, { 1 }), sn5 = f(snake_case, { 1 }), sn6 = f(snake_case, { 1 }),
            sn7 = f(snake_case, { 1 }), sn8 = f(snake_case, { 1 }), sn9 = f(snake_case, { 1 }),
            sn10 = f(snake_case, { 1 }), sn11 = f(snake_case, { 1 }), sn12 = f(snake_case, { 1 }),
            sn13 = f(snake_case, { 1 }), sn14 = f(snake_case, { 1 }), sn15 = f(snake_case, { 1 }),
            sn16 = f(snake_case, { 1 }),
            snp1 = f(snake_case_plural, { 1 }),
        })
    ),

    s({ trig = "dviewperm", name = "Django Permissioned View", dscr = "FBV with login_required and permission_required" },
        fmta([[
from django.contrib.auth.decorators import login_required, permission_required
from django.shortcuts import render, get_object_or_404
from .models import <model>


@login_required  # redirects to LOGIN_URL if not authenticated
@permission_required("<perm>", raise_exception=True)  # returns 403 if user lacks this permission
def <view_name>(request, pk):
    obj = get_object_or_404(<r1>, pk=pk)
    <finish>
    return render(request, "<app>/<tpl>.html", {"<ctx>": obj})
]], {
            model = i(1, "ModelName"),
            perm = i(2, "app.view_modelname"),
            view_name = i(3, "model_detail"),
            r1 = rep(1),
            finish = i(0),
            app = i(4, "app"),
            tpl = i(5, "model_detail"),
            ctx = i(6, "object"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  DJANGO REST FRAMEWORK                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dserializer", name = "DRF ModelSerializer", dscr = "Basic ModelSerializer" },
        fmta([[
from rest_framework import serializers
from .models import <model>


class <r1>Serializer(serializers.ModelSerializer):
    class Meta:  # controls serialization
        model = <r2>
        fields = <fields>  # "__all__" or list of field names
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            fields = c(2, { t('"__all__"'), t('["id", "name", "created_at"]') }),
            finish = i(0),
        })
    ),

    s({ trig = "dserializerfull", name = "DRF Full Serializer", dscr = "Serializer with validation and custom create" },
        fmta([[
from rest_framework import serializers
from .models import <model>


class <r1>Serializer(serializers.ModelSerializer):
    <extra_field> = serializers.<field_type>(<field_args>)  # custom computed or extra field

    class Meta:
        model = <r2>
        fields = [<fields>]
        read_only_fields = [<readonly>]  # these fields can't be set via API

    def validate_<val_field>(self, value):  # field-level validation
        <validation>
        return value

    def create(self, validated_data):  # custom logic before saving to DB
        <finish>
        return super().create(validated_data)
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            extra_field = i(2, "url"),
            field_type = c(3, {
                t("SerializerMethodField"), t("CharField"),
                t("IntegerField"), t("SlugRelatedField"),
            }),
            field_args = i(4, ""),
            fields = i(5, '"__all__"'),
            readonly = i(6, '"id", "created_at"'),
            val_field = i(7, "name"),
            validation = i(8, 'if len(value) < 3:\n            raise serializers.ValidationError("Too short.")'),
            finish = i(0),
        })
    ),

    s({ trig = "dsermethod", name = "DRF SerializerMethodField", dscr = "SerializerMethodField with get_ method" },
        fmta([[
<field_name> = serializers.SerializerMethodField()  # calls get_ method below

def get_<field_rep>(self, obj):  # obj is the model instance being serialized
    <finish>]], {
            field_name = i(1, "field_name"),
            field_rep = rep(1),
            finish = i(0, "return None"),
        })
    ),

    s({ trig = "dviewset", name = "DRF ModelViewSet", dscr = "Full ModelViewSet" },
        fmta([[
from rest_framework import viewsets
from .models import <model>
from .serializers import <r1>Serializer


class <r2>ViewSet(viewsets.ModelViewSet):  # provides list/create/retrieve/update/destroy
    queryset = <r3>.objects.all()  # base queryset for all operations
    serializer_class = <r4>Serializer  # how data is serialized/validated
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1),
            finish = i(0),
        })
    ),

    s({ trig = "dapiview", name = "DRF APIView", dscr = "APIView with GET and POST" },
        fmta([[
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import <model>
from .serializers import <r1>Serializer


class <r2>APIView(APIView):
    def get(self, request):  # handles GET requests (list)
        queryset = <r3>.objects.all()
        serializer = <r4>Serializer(queryset, many=True)  # many=True for lists
        return Response(serializer.data)

    def post(self, request):  # handles POST requests (create)
        serializer = <r5>Serializer(data=request.data)
        if serializer.is_valid():  # validates against serializer rules
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1), r5 = rep(1),
        })
    ),

    s({ trig = "drfcrud", name = "DRF Full CRUD", dscr = "Serializer + ViewSet + Router in one shot" },
        fmta([[
from rest_framework import serializers, viewsets, routers
from .models import <model>


class <r1>Serializer(serializers.ModelSerializer):
    class Meta:
        model = <r2>
        fields = <fields>


class <r3>ViewSet(viewsets.ModelViewSet):
    queryset = <r4>.objects.all()
    serializer_class = <r5>Serializer


router = routers.DefaultRouter()  # auto-generates URL patterns for ViewSet
router.register(r"<url_prefix>", <r6>ViewSet)  # maps URL prefix to ViewSet (creates list/detail/etc.)
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1), r5 = rep(1), r6 = rep(1),
            fields = c(2, { t('"__all__"'), t('["id", "name", "created_at"]') }),
            url_prefix = f(snake_case_plural, { 1 }),
        })
    ),

    s({ trig = "dpermission", name = "DRF Permission", dscr = "Custom DRF permission class" },
        fmta([[
from rest_framework.permissions import BasePermission


class <name>(BasePermission):
    message = "<message>"

    def has_permission(self, request, view):  # checked on every request
        <perm_body>

    def has_object_permission(self, request, view, obj):  # checked per-object (detail/update/delete)
        <finish>
]], {
            name = i(1, "IsOwner"),
            message = i(2, "You do not have permission to perform this action."),
            perm_body = i(3, "return request.user.is_authenticated"),
            finish = i(0, "return obj.owner == request.user"),
        })
    ),

    s({ trig = "dfilter", name = "Django FilterSet", dscr = "django-filter FilterSet" },
        fmta([[
import django_filters
from .models import <model>


class <r1>Filter(django_filters.FilterSet):
    class Meta:
        model = <r2>
        fields = {
            "<field1>": [<lookups1>],  # lookup types: exact, icontains, etc.
            "<field2>": [<lookups2>],  # gte = greater-or-equal, lte = less-or-equal
        }
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            field1 = i(2, "name"),
            lookups1 = i(3, '"exact", "icontains"'),
            field2 = i(4, "created_at"),
            lookups2 = i(5, '"gte", "lte"'),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  FORMS                                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dform", name = "Django ModelForm", dscr = "ModelForm with widgets" },
        fmta([[
from django import forms
from .models import <model>


class <r1>Form(forms.ModelForm):
    class Meta:
        model = <r2>
        fields = [<fields>]  # which model fields to include
        widgets = {  # customize HTML input rendering
            <finish>
        }
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            fields = i(2, '"name", "description"'),
            finish = i(0),
        })
    ),

    s({ trig = "dformval", name = "Django Form + Validation", dscr = "ModelForm with custom clean methods" },
        fmta([[
from django import forms
from .models import <model>


class <r1>Form(forms.ModelForm):
    class Meta:
        model = <r2>
        fields = [<fields>]

    def clean_<field_name>(self):  # field-level validation
        value = self.cleaned_data.get("<field_rep>")  # already-parsed form data
        if not value:
            raise forms.ValidationError("<validation_msg>")  # rejects the form submission
        return value

    def clean(self):  # cross-field validation
        cleaned_data = super().clean()  # get all validated field data
        <finish>
        return cleaned_data
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            fields = i(2, '"name", "email"'),
            field_name = i(3, "name"),
            field_rep = rep(3),
            validation_msg = i(4, "This field is required."),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  URLS                                                       ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "durlscrud", name = "Django CRUD URLs", dscr = "URL patterns for CRUD class-based views" },
        fmta([[
from django.urls import path
from . import views

app_name = "<app>"  # namespace for url reversing

urlpatterns = [
    path("", views.<model>ListView.as_view(), name="<sn1>-list"),  # list view
    path("<<int:pk>>/", views.<r1>DetailView.as_view(), name="<sn2>-detail"),  # detail view
    path("create/", views.<r2>CreateView.as_view(), name="<sn3>-create"),  # create form
    path("<<int:pk>>/update/", views.<r3>UpdateView.as_view(), name="<sn4>-update"),  # edit form
    path("<<int:pk>>/delete/", views.<r4>DeleteView.as_view(), name="<sn5>-delete"),  # delete confirmation
]
]], {
            app = i(1, "app"),
            model = i(2, "ModelName"),
            r1 = rep(2), r2 = rep(2), r3 = rep(2), r4 = rep(2),
            sn1 = f(snake_case, { 2 }), sn2 = f(snake_case, { 2 }), sn3 = f(snake_case, { 2 }),
            sn4 = f(snake_case, { 2 }), sn5 = f(snake_case, { 2 }),
        })
    ),

    s({ trig = "durlsapi", name = "Django DRF URLs", dscr = "URL patterns with DRF router" },
        fmta([[
from django.urls import path, include
from rest_framework import routers
from . import views

router = routers.DefaultRouter()  # auto-generates URL conf
router.register(r"<prefix>", views.<viewset>ViewSet)  # creates /prefix/ and /prefix/pk/ endpoints

urlpatterns = [
    path("", include(router.urls)),  # mount all router URLs
]
]], {
            prefix = i(1, "items"),
            viewset = i(2, "ModelName"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  ADMIN                                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dadmin", name = "Django ModelAdmin", dscr = "ModelAdmin with common options" },
        fmta([[
from django.contrib import admin
from .models import <model>


@admin.register(<r1>)  # registers model with this admin config
class <r2>Admin(admin.ModelAdmin):
    list_display = [<list_display>]  # columns shown in changelist
    list_filter = [<list_filter>]  # sidebar filters
    search_fields = [<search_fields>]  # enables search box
    ordering = [<ordering>]  # default sort order
<finish>]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            list_display = i(2, '"id", "name", "created_at"'),
            list_filter = i(3, '"created_at"'),
            search_fields = i(4, '"name"'),
            ordering = i(5, '"-created_at"'),
            finish = i(0),
        })
    ),

    s({ trig = "dadmininline", name = "Django Inline Admin", dscr = "TabularInline with parent ModelAdmin" },
        fmta([[
from django.contrib import admin
from .models import <parent_model>, <inline_model>


class <r1>Inline(admin.TabularInline):  # shows child objects in parent admin page
    model = <r2>
    extra = <extra_count>  # number of empty forms to display


@admin.register(<r3>)
class <r4>Admin(admin.ModelAdmin):
    list_display = [<list_display>]
    inlines = [<r5>Inline]  # embed inline forms
<finish>]], {
            parent_model = i(1, "ParentModel"),
            inline_model = i(2, "ChildModel"),
            r1 = rep(2), r2 = rep(2),
            extra_count = i(3, "1"),
            r3 = rep(1), r4 = rep(1),
            list_display = i(4, '"id", "name"'),
            r5 = rep(2),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  SIGNALS, MIDDLEWARE, COMMANDS, TESTS                       ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "dsignal", name = "Django Signal", dscr = "Signal handler with @receiver" },
        fmta([[
from django.db.models.signals import <signal_type>
from django.dispatch import receiver
from .models import <model>


@receiver(<signal_rep>, sender=<r1>)  # runs when this signal is fired
def <handler_name>(sender, instance, **kwargs):  # instance is the model object
    <finish>
]], {
            signal_type = c(1, {
                t("post_save"), t("pre_save"),
                t("post_delete"), t("pre_delete"),
                t("m2m_changed"),
            }),
            model = i(2, "ModelName"),
            signal_rep = rep(1),
            r1 = rep(2),
            handler_name = i(3, "handle_model_save"),
            finish = i(0, "pass"),
        })
    ),

    s({ trig = "dcommand", name = "Django Management Command", dscr = "Custom management command" },
        fmta([[
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "<help_text>"  # shown in --help output

    def add_arguments(self, parser):  # define CLI arguments
        parser.add_argument("<arg_name>", type=<arg_type>, help="<arg_help>")

    def handle(self, *args, **options):  # main command logic
        <finish>
        self.stdout.write(self.style.SUCCESS("<success_msg>"))  # colored terminal output
]], {
            help_text = i(1, "Description of the command"),
            arg_name = i(2, "name"),
            arg_type = c(3, { t("str"), t("int"), t("float") }),
            arg_help = i(4, "Argument description"),
            finish = i(0, "pass"),
            success_msg = i(5, "Command completed successfully"),
        })
    ),

    s({ trig = "dmiddleware", name = "Django Middleware", dscr = "Custom middleware class" },
        fmta([[
class <name>:
    def __init__(self, get_response):
        self.get_response = get_response  # the next middleware or view in chain

    def __call__(self, request):
        <before>
        response = self.get_response(request)  # calls the view
        <finish>
        return response
]], {
            name = i(1, "CustomMiddleware"),
            before = i(2, "# before view"),
            finish = i(0, "# after view"),
        })
    ),

    s({ trig = "dtestcase", name = "Django TestCase", dscr = "TestCase with setUp and test method" },
        fmta([[
from django.test import TestCase
from .models import <model>


class <r1>Tests(TestCase):
    def setUp(self):  # runs before each test method
        self.<sn1> = <r2>.objects.create(
            <setup_fields>
        )

    def test_<test_name>(self):  # method name must start with test_
        <finish>
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            sn1 = f(snake_case, { 1 }),
            setup_fields = i(2, 'name="Test"'),
            test_name = i(3, "str_representation"),
            finish = i(0, 'self.assertEqual(str(self.obj), "Test")'),
        })
    ),

    s({ trig = "dtestapi", name = "DRF API TestCase", dscr = "Full API test case with CRUD tests" },
        fmta([[
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from .models import <model>


class <r1>APITests(APITestCase):
    def setUp(self):
        self.<sn1> = <r2>.objects.create(
            <setup_fields>
        )
        self.list_url = reverse("<sn2>-list")  # resolve URL name to path
        self.detail_url = reverse("<sn3>-detail", kwargs={"pk": self.<sn4>.pk})  # URL for specific object

    def test_list(self):
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create(self):
        data = {<create_data>}
        response = self.client.post(self.list_url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_retrieve(self):
        response = self.client.get(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_update(self):
        data = {<update_data>}
        response = self.client.put(self.detail_url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete(self):
        response = self.client.delete(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
]], {
            model = i(1, "ModelName"),
            r1 = rep(1), r2 = rep(1),
            sn1 = f(snake_case, { 1 }), sn2 = f(snake_case, { 1 }),
            sn3 = f(snake_case, { 1 }), sn4 = f(snake_case, { 1 }),
            setup_fields = i(2, 'name="Test"'),
            create_data = i(3, '"name": "New"'),
            update_data = i(4, '"name": "Updated"'),
        })
    ),

    s({ trig = "dmigration", name = "Django Data Migration", dscr = "Custom data migration with RunPython" },
        fmta([[
from django.db import migrations


def forward_func(apps, schema_editor):
    <model> = apps.get_model("<app_label>", "<r1>")  # historical model version, not current code
    <forward_body>


def reverse_func(apps, schema_editor):
    <reverse_body>


class Migration(migrations.Migration):
    dependencies = [
        ("<app_rep>", "<prev_migration>"),
    ]

    operations = [
        migrations.RunPython(forward_func, reverse_func),  # forward fn, rollback fn
    ]
]], {
            model = i(1, "ModelName"),
            app_label = i(2, "app"),
            r1 = rep(1),
            forward_body = i(3, "pass"),
            reverse_body = i(4, "pass"),
            app_rep = rep(2),
            prev_migration = i(5, "0001_initial"),
        })
    ),

    s({ trig = "dtask", name = "Celery Task", dscr = "Celery shared_task with retry" },
        fmta([[
from celery import shared_task
from .models import <model>


@shared_task(bind=True, max_retries=<retries>)  # bind=True gives access to self for retry
def <task_name>(self, <args>):
    try:
        <finish>
    except Exception as exc:
        self.retry(exc=exc, countdown=<countdown>)  # retry after countdown seconds
]], {
            model = i(1, "ModelName"),
            retries = i(2, "3"),
            task_name = i(3, "process_model"),
            args = i(4, "pk"),
            finish = i(0, "pass"),
            countdown = i(5, "60"),
        })
    ),

    s({ trig = "dapp", name = "Django AppConfig", dscr = "App configuration with ready()" },
        fmta([[
from django.apps import AppConfig


class <name>Config(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"  # primary key type for all models
    name = "<app_name>"  # must match the app directory name
    verbose_name = "<verbose>"

    def ready(self):  # called once at Django startup
        import <app_import>.signals  # noqa: F401  # registers signal handlers
]], {
            name = i(1, "MyApp"),
            app_name = i(2, "myapp"),
            verbose = i(3, "My Application"),
            app_import = rep(2),
        })
    ),
}
