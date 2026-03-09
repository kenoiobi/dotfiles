local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local function snake_case(args)
    local name = args[1][1]
    if not name or name == "" then return "item" end
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
    -- ║  BASE SETUP                                                  ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "sabase", name = "SQLAlchemy Base", dscr = "Async engine, session, and declarative base" },
        fmta([[
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase

DATABASE_URL = "<db_url>"

engine = create_async_engine(DATABASE_URL, echo=<echo>)  # echo=True logs SQL to console
async_session = async_sessionmaker(engine, expire_on_commit=False)  # prevents lazy-load errors after commit


class Base(DeclarativeBase):  # all ORM models inherit from this
    pass


async def get_session() ->> AsyncSession:  # type: ignore[misc]
    async with async_session() as session:
        yield session  # session auto-closed when the caller is done


async def create_tables():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)  # creates all tables that don't exist yet
<finish>]], {
            db_url = i(1, "sqlite+aiosqlite:///./db.sqlite3"),
            echo = c(2, { t("False"), t("True") }),
            finish = i(0),
        })
    ),

    s({ trig = "sabasesync", name = "SQLAlchemy Sync Base", dscr = "Sync engine, session, and declarative base" },
        fmta([[
from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

DATABASE_URL = "<db_url>"

engine = create_engine(DATABASE_URL, echo=<echo>)  # echo=True logs SQL to console
SessionLocal = sessionmaker(bind=engine)  # factory for creating new sessions


class Base(DeclarativeBase):  # all ORM models inherit from this
    pass


def get_session():  # use as a FastAPI dependency with Depends()
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()  # always close, even if an exception occurred
<finish>]], {
            db_url = i(1, "sqlite:///./db.sqlite3"),
            echo = c(2, { t("False"), t("True") }),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  MODELS                                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "samodel", name = "SQLAlchemy Model", dscr = "Model with timestamps" },
        fmta([[
from datetime import datetime
from sqlalchemy import String, func
from sqlalchemy.orm import Mapped, mapped_column

from <base_module> import Base


class <model>(Base):
    __tablename__ = "<tablename>"  # actual table name in the database

    id: Mapped[int] = mapped_column(primary_key=True)  # auto-incrementing primary key
    <field1>: Mapped[<type1>] = mapped_column(<col_type1>)
    <field2>: Mapped[<type2>] = mapped_column(<col_type2>)
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())  # set by DB on insert
    updated_at: Mapped[datetime] = mapped_column(server_default=func.now(), onupdate=func.now())  # set by DB on update

    def __repr__(self) ->> str:  # shown in logs and debugger
        return f"<<<r1>(id={self.id}, <field1_r>={self.<field1_r2>})>>"
<finish>]], {
            base_module = i(1, "app.db"),
            model = i(2, "Item"),
            tablename = f(snake_case_plural, { 2 }),
            field1 = i(3, "name"), field1_r = rep(3), field1_r2 = rep(3),
            type1 = c(4, { t("str"), t("int"), t("float"), t("bool") }),
            col_type1 = i(5, "String(255)"),
            field2 = i(6, "description"),
            type2 = c(7, { t("str | None"), t("str"), t("int | None"), t("int") }),
            col_type2 = i(8, "String(500), nullable=True"),
            r1 = rep(2),
            finish = i(0),
        })
    ),

    s({ trig = "samodelfull", name = "SQLAlchemy Full Model", dscr = "Model with all common column types" },
        fmta([[
from datetime import datetime
from sqlalchemy import String, Text, Integer, Boolean, func
from sqlalchemy.orm import Mapped, mapped_column

from <base_module> import Base


class <model>(Base):
    __tablename__ = "<tablename>"

    id: Mapped[int] = mapped_column(primary_key=True)
    <name_field>: Mapped[str] = mapped_column(String(<max_len>))  # VARCHAR with max length
    <desc_field>: Mapped[str | None] = mapped_column(Text, nullable=True)  # unlimited text, optional
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)  # Python-side default
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())  # DB-side default
    updated_at: Mapped[datetime] = mapped_column(server_default=func.now(), onupdate=func.now())

    def __repr__(self) ->> str:
        return f"<<<r1>(id={self.id}, <name_r>={self.<name_r2>})>>"
<finish>]], {
            base_module = i(1, "app.db"),
            model = i(2, "Item"),
            r1 = rep(2),
            tablename = f(snake_case_plural, { 2 }),
            name_field = i(3, "name"), name_r = rep(3), name_r2 = rep(3),
            max_len = i(4, "255"),
            desc_field = i(5, "description"),
            finish = i(0),
        })
    ),

    s({ trig = "samixin", name = "SQLAlchemy Timestamp Mixin", dscr = "Reusable mixin with created_at/updated_at" },
        fmta([[
from datetime import datetime
from sqlalchemy import func
from sqlalchemy.orm import Mapped, mapped_column, declared_attr


class TimestampMixin:  # add to model: class MyModel(TimestampMixin, Base)
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(server_default=func.now(), onupdate=func.now())


class SlugMixin:  # adds a unique, indexed slug column
    @declared_attr  # defers column creation to when the mixin is used
    def slug(cls) ->> Mapped[str]:
        from sqlalchemy import String
        return mapped_column(String(<slug_len>), unique=True, index=True)
<finish>]], {
            slug_len = i(1, "255"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  RELATIONSHIPS                                               ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "safk", name = "SQLAlchemy ForeignKey", dscr = "ForeignKey column with relationship" },
        fmta([[
from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

# on the child model:
<fk_field>: Mapped[int] = mapped_column(ForeignKey("<parent_table>.id"))  # DB-level constraint
<rel_field>: Mapped["<parent_model>"] = relationship(back_populates="<back_pop>")  # ORM-level navigation
<finish>]], {
            fk_field = i(1, "author_id"),
            parent_table = i(2, "users"),
            rel_field = i(3, "author"),
            parent_model = i(4, "User"),
            back_pop = i(5, "posts"),
            finish = i(0),
        })
    ),

    s({ trig = "sao2m", name = "SQLAlchemy One-to-Many", dscr = "Parent and child models with one-to-many" },
        fmta([=[
from sqlalchemy import String, ForeignKey, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime

from <base_module> import Base


class <parent>(Base):
    __tablename__ = "<parent_table>"

    id: Mapped[int] = mapped_column(primary_key=True)
    <parent_field>: Mapped[str] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())

    # one-to-many: one parent has many children; cascade deletes children when parent is deleted
    <children_rel>: Mapped[list["<child>"]] = relationship(back_populates="<parent_rel>", cascade="all, delete-orphan")

    def __repr__(self) ->> str:
        return f"<<<r1>(id={self.id})>>"


class <child_r>(Base):
    __tablename__ = "<child_table>"

    id: Mapped[int] = mapped_column(primary_key=True)
    <child_field>: Mapped[str] = mapped_column(String(255))
    <fk_field>: Mapped[int] = mapped_column(ForeignKey("<parent_table_r>.id"))  # points to parent's PK
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())

    <parent_rel_r>: Mapped["<r2>"] = relationship(back_populates="<children_rel_r>")  # navigates child ->> parent

    def __repr__(self) ->> str:
        return f"<<<child_r2>(id={self.id})>>"
<finish>]=], {
            base_module = i(1, "app.db"),
            parent = i(2, "User"),
            r1 = rep(2), r2 = rep(2),
            parent_table = i(3, "users"), parent_table_r = rep(3),
            parent_field = i(4, "name"),
            child = i(5, "Post"), child_r = rep(5), child_r2 = rep(5),
            child_table = i(6, "posts"),
            child_field = i(7, "title"),
            children_rel = i(8, "posts"), children_rel_r = rep(8),
            parent_rel = i(9, "author"), parent_rel_r = rep(9),
            fk_field = i(10, "author_id"),
            finish = i(0),
        })
    ),

    s({ trig = "sam2m", name = "SQLAlchemy Many-to-Many", dscr = "Association table with many-to-many relationship" },
        fmta([=[
from sqlalchemy import Table, Column, ForeignKey, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime

from <base_module> import Base

# association table: no ORM model needed, just stores FK pairs
<assoc_table> = Table(
    "<assoc_name>",
    Base.metadata,
    Column("<left_fk>", ForeignKey("<left_table>.id"), primary_key=True),
    Column("<right_fk>", ForeignKey("<right_table>.id"), primary_key=True),
)


class <left_model>(Base):
    __tablename__ = "<left_table_r>"

    id: Mapped[int] = mapped_column(primary_key=True)
    <left_field>: Mapped[str] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())

    # secondary= points to the association table; back_populates links both sides
    <left_rel>: Mapped[list["<right_model>"]] = relationship(secondary=<assoc_table_r>, back_populates="<right_rel>")


class <right_model_r>(Base):
    __tablename__ = "<right_table_r>"

    id: Mapped[int] = mapped_column(primary_key=True)
    <right_field>: Mapped[str] = mapped_column(String(255))

    <right_rel_r>: Mapped[list["<r1>"]] = relationship(secondary=<assoc_table_r2>, back_populates="<left_rel_r>")
<finish>]=], {
            base_module = i(1, "app.db"),
            assoc_table = i(2, "post_tags"),
            assoc_name = rep(2), assoc_table_r = rep(2), assoc_table_r2 = rep(2),
            left_fk = i(3, "post_id"),
            left_table = i(4, "posts"), left_table_r = rep(4),
            right_fk = i(5, "tag_id"),
            right_table = i(6, "tags"), right_table_r = rep(6),
            left_model = i(7, "Post"),
            r1 = rep(7),
            left_field = i(8, "title"),
            left_rel = i(9, "tags"), left_rel_r = rep(9),
            right_model = i(10, "Tag"), right_model_r = rep(10),
            right_field = i(11, "name"),
            right_rel = i(12, "posts"), right_rel_r = rep(12),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  ENUM                                                        ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "saenum", name = "SQLAlchemy Enum Column", dscr = "Python enum with SQLAlchemy column" },
        fmta([[
import enum
from sqlalchemy import Enum
from sqlalchemy.orm import Mapped, mapped_column


class <name>(str, enum.Enum):  # str mixin makes values JSON-serializable
    <val1> = "<key1>"  # CONSTANT = "db_value"
    <val2> = "<key2>"
    <val3> = "<key3>"


<field>: Mapped[<r1>] = mapped_column(Enum(<r2>), default=<r3>.<default>)  # stores as VARCHAR in DB
<finish>]], {
            name = i(1, "Status"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1),
            val1 = i(2, "DRAFT"), key1 = i(3, "draft"),
            val2 = i(4, "PUBLISHED"), key2 = i(5, "published"),
            val3 = i(6, "ARCHIVED"), key3 = i(7, "archived"),
            field = i(8, "status"),
            default = rep(2),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  QUERIES / CRUD                                              ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "sacrud", name = "SQLAlchemy Async CRUD", dscr = "Async CRUD helper functions" },
        fmta([[
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from <models_module> import <model>


async def create_<sn>(session: AsyncSession, **kwargs) ->> <r1>:
    obj = <r2>(**kwargs)  # instantiate ORM model from keyword args
    session.add(obj)  # stage for insert
    await session.commit()  # flush to DB
    await session.refresh(obj)  # reload DB-generated fields (id, timestamps)
    return obj


async def get_<sn2>(session: AsyncSession, <sn3>_id: int) ->> <r3> | None:
    return await session.get(<r4>, <sn4>_id)  # fetch by primary key, returns None if not found


async def list_<snp>(session: AsyncSession, skip: int = 0, limit: int = 100) ->> list[<r5>]:
    result = await session.execute(select(<r6>).offset(skip).limit(limit))
    return list(result.scalars().all())  # scalars() extracts ORM objects from result rows


async def update_<sn5>(session: AsyncSession, <sn6>_id: int, **kwargs) ->> <r7> | None:
    obj = await session.get(<r8>, <sn7>_id)
    if not obj:
        return None
    for key, value in kwargs.items():
        setattr(obj, key, value)  # update each field on the ORM object
    await session.commit()
    await session.refresh(obj)
    return obj


async def delete_<sn8>(session: AsyncSession, <sn9>_id: int) ->> bool:
    obj = await session.get(<r9>, <sn10>_id)
    if not obj:
        return False
    await session.delete(obj)  # stage for deletion
    await session.commit()
    return True
<finish>]], {
            models_module = i(1, "app.models"),
            model = i(2, "Item"),
            r1 = rep(2), r2 = rep(2), r3 = rep(2), r4 = rep(2), r5 = rep(2),
            r6 = rep(2), r7 = rep(2), r8 = rep(2), r9 = rep(2),
            sn = f(snake_case, { 2 }), sn2 = f(snake_case, { 2 }), sn3 = f(snake_case, { 2 }),
            sn4 = f(snake_case, { 2 }), sn5 = f(snake_case, { 2 }), sn6 = f(snake_case, { 2 }),
            sn7 = f(snake_case, { 2 }), sn8 = f(snake_case, { 2 }), sn9 = f(snake_case, { 2 }),
            sn10 = f(snake_case, { 2 }),
            snp = f(snake_case_plural, { 2 }),
            finish = i(0),
        })
    ),

    s({ trig = "saquery", name = "SQLAlchemy Query", dscr = "Common async query patterns" },
        fmta([[
from sqlalchemy import select, func, and_, or_
from sqlalchemy.ext.asyncio import AsyncSession

from <models_module> import <model>


async def query_examples(session: AsyncSession):
    # basic filter: WHERE name = "test"
    stmt = select(<r1>).where(<r2>.<field> == <value>)
    result = await session.execute(stmt)
    items = result.scalars().all()

    # multiple conditions with AND, plus ordering and limit
    stmt = select(<r3>).where(
        and_(
            <r4>.<field_r> == <value_r>,
            <r5>.is_active == True,
        )
    ).order_by(<r6>.created_at.desc()).limit(<limit>)  # newest first

    # aggregate: SELECT COUNT(*) FROM items
    stmt = select(func.count()).select_from(<r7>)
    count = (await session.execute(stmt)).scalar()  # scalar() returns single value
    <finish>]], {
            models_module = i(1, "app.models"),
            model = i(2, "Item"),
            r1 = rep(2), r2 = rep(2), r3 = rep(2), r4 = rep(2),
            r5 = rep(2), r6 = rep(2), r7 = rep(2),
            field = i(3, "name"), field_r = rep(3),
            value = i(4, '"test"'), value_r = rep(4),
            limit = i(5, "10"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  ALEMBIC                                                     ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "sarevision", name = "Alembic Revision", dscr = "Manual Alembic migration revision" },
        fmta([[
"""<message>"""

from alembic import op
import sqlalchemy as sa

revision = "<rev_id>"  # unique ID for this migration
down_revision = <down_rev>  # parent migration; None if this is the first
branch_labels = None
depends_on = None


def upgrade() ->> None:  # applied with: alembic upgrade head
    op.<upgrade_op>(
        "<table>",
        sa.Column("<col_name>", sa.<col_type>, <col_args>),
    )


def downgrade() ->> None:  # applied with: alembic downgrade -1
    op.<downgrade_op>("<table_r>", "<col_name_r>")
<finish>]], {
            message = i(1, "add column to table"),
            rev_id = i(2, "xxxx"),
            down_rev = i(3, "None"),
            upgrade_op = c(4, { t("add_column"), t("create_table"), t("drop_column"), t("alter_column") }),
            table = i(5, "items"), table_r = rep(5),
            col_name = i(6, "email"), col_name_r = rep(6),
            col_type = c(7, { t("String(255)"), t("Integer"), t("Boolean"), t("Text"), t("DateTime") }),
            col_args = i(8, "nullable=True"),
            downgrade_op = c(9, { t("drop_column"), t("drop_table"), t("add_column") }),
            finish = i(0),
        })
    ),

    s({ trig = "saindex", name = "SQLAlchemy Index", dscr = "Composite or custom index" },
        fmta([[
from sqlalchemy import Index

# add inside model class as __table_args__, or after model definition
__table_args__ = (
    Index("<idx_name>", "<col1>", "<col2>", unique=<unique>),  # composite index on two columns
)
<finish>]], {
            idx_name = i(1, "ix_model_col1_col2"),
            col1 = i(2, "name"),
            col2 = i(3, "created_at"),
            unique = c(4, { t("False"), t("True") }),
            finish = i(0),
        })
    ),
}
