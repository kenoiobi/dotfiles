local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node
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
    -- ║  APP SETUP                                                   ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "faapp", name = "FastAPI App", dscr = "FastAPI application with lifespan" },
        fmta([[
from contextlib import asynccontextmanager
from fastapi import FastAPI


@asynccontextmanager
async def lifespan(app: FastAPI):  # replaces deprecated on_event("startup"/"shutdown")
    # startup: runs before the app starts accepting requests
    <startup>
    yield  # app runs while yielded; cleanup goes after yield
    # shutdown: runs when the app is stopping
    <shutdown>


app = FastAPI(
    title="<title>",
    version="<version>",
    lifespan=lifespan,  # manages startup/shutdown lifecycle
)
<finish>]], {
            startup = i(1, "pass"),
            shutdown = i(2, "pass"),
            title = i(3, "My API"),
            version = i(4, "0.1.0"),
            finish = i(0),
        })
    ),

    s({ trig = "faappmin", name = "FastAPI Minimal App", dscr = "Minimal FastAPI application" },
        fmta([[
from fastapi import FastAPI

app = FastAPI()


@app.get("/")  # responds to GET requests at root path
async def root():
    return {"message": "<message>"}  # auto-serialized to JSON
<finish>]], {
            message = i(1, "Hello World"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  ROUTES                                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "faget", name = "FastAPI GET", dscr = "GET endpoint" },
        fmta([[
@<app>.get("/<path>", response_model=<response>)  # response_model validates & filters output
async def <func_name>(<params>):
    <finish>]], {
            app = c(1, { t("app"), t("router") }),
            path = i(2, "items"),
            response = i(3, "list[dict]"),
            func_name = i(4, "get_items"),
            params = i(5, ""),
            finish = i(0, "pass"),
        })
    ),

    s({ trig = "fapost", name = "FastAPI POST", dscr = "POST endpoint" },
        fmta([[
@<app>.post("/<path>", response_model=<response>, status_code=status.HTTP_201_CREATED)
async def <func_name>(<params>):  # request body auto-parsed from JSON via type hint
    <finish>]], {
            app = c(1, { t("app"), t("router") }),
            path = i(2, "items"),
            response = i(3, "dict"),
            func_name = i(4, "create_item"),
            params = i(5, ""),
            finish = i(0, "pass"),
        })
    ),

    s({ trig = "faput", name = "FastAPI PUT", dscr = "PUT endpoint" },
        fmta([[
@<app>.put("/<path>/{<path_param>}", response_model=<response>)  # {path_param} captured from URL
async def <func_name>(<path_param_r>: <param_type>, <params>):
    <finish>]], {
            app = c(1, { t("app"), t("router") }),
            path = i(2, "items"),
            path_param = i(3, "item_id"),
            response = i(4, "dict"),
            func_name = i(5, "update_item"),
            path_param_r = rep(3),
            param_type = c(6, { t("int"), t("str"), t("UUID") }),
            params = i(7, ""),
            finish = i(0, "pass"),
        })
    ),

    s({ trig = "fadelete", name = "FastAPI DELETE", dscr = "DELETE endpoint" },
        fmta([[
@<app>.delete("/<path>/{<path_param>}", status_code=status.HTTP_204_NO_CONTENT)  # 204 = no response body
async def <func_name>(<path_param_r>: <param_type>):
    <finish>]], {
            app = c(1, { t("app"), t("router") }),
            path = i(2, "items"),
            path_param = i(3, "item_id"),
            func_name = i(4, "delete_item"),
            path_param_r = rep(3),
            param_type = c(5, { t("int"), t("str"), t("UUID") }),
            finish = i(0, "pass"),
        })
    ),

    s({ trig = "fapatch", name = "FastAPI PATCH", dscr = "PATCH endpoint for partial update" },
        fmta([[
@<app>.patch("/<path>/{<path_param>}", response_model=<response>)  # PATCH = partial update (only changed fields)
async def <func_name>(<path_param_r>: <param_type>, <params>):
    <finish>]], {
            app = c(1, { t("app"), t("router") }),
            path = i(2, "items"),
            path_param = i(3, "item_id"),
            response = i(4, "dict"),
            func_name = i(5, "patch_item"),
            path_param_r = rep(3),
            param_type = c(6, { t("int"), t("str"), t("UUID") }),
            params = i(7, ""),
            finish = i(0, "pass"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  ROUTER                                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "farouter", name = "FastAPI APIRouter", dscr = "APIRouter with prefix and tags" },
        fmta([[
from fastapi import APIRouter, Depends, HTTPException, status

router = APIRouter(
    prefix="/<prefix>",  # all routes in this router are prefixed with this path
    tags=["<tag>"],  # groups endpoints in the OpenAPI docs
)


@router.get("/")
async def list_<snp>():
    <finish>


@router.get("/{<sn>_id}")
async def get_<sn2>(<sn3>_id: int):
    pass


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_<sn4>():
    pass


@router.put("/{<sn5>_id}")
async def update_<sn6>(<sn7>_id: int):
    pass


@router.delete("/{<sn8>_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_<sn9>(<sn10>_id: int):
    pass
]], {
            prefix = i(1, "items"),
            tag = i(2, "Items"),
            snp = f(snake_case_plural, { 2 }),
            sn = f(snake_case, { 2 }), sn2 = f(snake_case, { 2 }), sn3 = f(snake_case, { 2 }),
            sn4 = f(snake_case, { 2 }), sn5 = f(snake_case, { 2 }), sn6 = f(snake_case, { 2 }),
            sn7 = f(snake_case, { 2 }), sn8 = f(snake_case, { 2 }), sn9 = f(snake_case, { 2 }),
            sn10 = f(snake_case, { 2 }),
            finish = i(0, "pass"),
        })
    ),

    s({ trig = "fainclude", name = "Include Router", dscr = "Include an APIRouter in the app" },
        fmta([[app.include_router(<router>, prefix="/<prefix>", tags=["<tag>"])  # mounts router on the app]], {
            router = i(1, "router"),
            prefix = i(2, "api/v1"),
            tag = i(3, "v1"),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  CRUD ROUTER (with SQLAlchemy)                               ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "facrud", name = "FastAPI CRUD Router", dscr = "Complete CRUD router with async SQLAlchemy" },
        fmta([[
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from <db_module> import get_session
from <models_module> import <model>
from <schemas_module> import <r1>Create, <r2>Update, <r3>Response

router = APIRouter(prefix="/<prefix>", tags=["<tag>"])


@router.get("/", response_model=list[<r4>Response])
async def list_<snp>(
    skip: int = 0,  # query param: ?skip=10
    limit: int = 100,  # query param: ?limit=50
    session: AsyncSession = Depends(get_session),  # injected by FastAPI's DI
):
    result = await session.execute(select(<r5>).offset(skip).limit(limit))
    return result.scalars().all()  # extracts ORM objects from result rows


@router.get("/{<sn>_id}", response_model=<r6>Response)
async def get_<sn2>(
    <sn3>_id: int,  # path parameter from URL
    session: AsyncSession = Depends(get_session),
):
    obj = await session.get(<r7>, <sn4>_id)  # get by primary key
    if not obj:
        raise HTTPException(status_code=404, detail="<r8> not found")
    return obj


@router.post("/", response_model=<r9>Response, status_code=status.HTTP_201_CREATED)
async def create_<sn5>(
    data: <r10>Create,  # request body validated by Pydantic
    session: AsyncSession = Depends(get_session),
):
    obj = <r11>(**data.model_dump())  # convert Pydantic model to dict, unpack into ORM model
    session.add(obj)
    await session.commit()  # flush to DB
    await session.refresh(obj)  # reload to get DB-generated fields (id, timestamps)
    return obj


@router.put("/{<sn6>_id}", response_model=<r12>Response)
async def update_<sn7>(
    <sn8>_id: int,
    data: <r13>Update,
    session: AsyncSession = Depends(get_session),
):
    obj = await session.get(<r14>, <sn9>_id)
    if not obj:
        raise HTTPException(status_code=404, detail="<r15> not found")
    for key, value in data.model_dump(exclude_unset=True).items():  # only update fields that were sent
        setattr(obj, key, value)
    await session.commit()
    await session.refresh(obj)
    return obj


@router.delete("/{<sn10>_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_<sn11>(
    <sn12>_id: int,
    session: AsyncSession = Depends(get_session),
):
    obj = await session.get(<r16>, <sn13>_id)
    if not obj:
        raise HTTPException(status_code=404, detail="<r17> not found")
    await session.delete(obj)
    await session.commit()
]], {
            db_module = i(1, "app.db"),
            models_module = i(2, "app.models"),
            schemas_module = i(3, "app.schemas"),
            model = i(4, "Item"),
            r1 = rep(4), r2 = rep(4), r3 = rep(4), r4 = rep(4), r5 = rep(4),
            r6 = rep(4), r7 = rep(4), r8 = rep(4), r9 = rep(4), r10 = rep(4),
            r11 = rep(4), r12 = rep(4), r13 = rep(4), r14 = rep(4), r15 = rep(4),
            r16 = rep(4), r17 = rep(4),
            prefix = i(5, "items"),
            tag = i(6, "Items"),
            sn = f(snake_case, { 4 }), sn2 = f(snake_case, { 4 }), sn3 = f(snake_case, { 4 }),
            sn4 = f(snake_case, { 4 }), sn5 = f(snake_case, { 4 }), sn6 = f(snake_case, { 4 }),
            sn7 = f(snake_case, { 4 }), sn8 = f(snake_case, { 4 }), sn9 = f(snake_case, { 4 }),
            sn10 = f(snake_case, { 4 }), sn11 = f(snake_case, { 4 }), sn12 = f(snake_case, { 4 }),
            sn13 = f(snake_case, { 4 }),
            snp = f(snake_case_plural, { 4 }),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  SCHEMAS (Pydantic)                                          ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "faschema", name = "Pydantic Schema", dscr = "Pydantic model for request/response validation" },
        fmta([[
from pydantic import BaseModel


class <name>(BaseModel):  # validates and serializes request/response data
    <field1>: <type1>
    <field2>: <type2>
<finish>]], {
            name = i(1, "ItemSchema"),
            field1 = i(2, "name"),
            type1 = c(3, { t("str"), t("int"), t("float"), t("bool") }),
            field2 = i(4, "description"),
            type2 = c(5, { t("str | None = None"), t("str"), t("int"), t("float | None = None") }),
            finish = i(0),
        })
    ),

    s({ trig = "fascrud", name = "Pydantic CRUD Schemas", dscr = "Create/Update/Response schemas for a resource" },
        fmta([[
from datetime import datetime
from pydantic import BaseModel, ConfigDict


class <name>Base(BaseModel):  # shared fields between create and response
    <field1>: <type1>
    <field2>: <type2>


class <r1>Create(<r2>Base):  # fields required when creating
    pass


class <r3>Update(BaseModel):  # all optional for partial updates
    <field1_r>: <type1_opt> = None
    <field2_r>: <type2_opt> = None


class <r4>Response(<r5>Base):  # what the API returns
    model_config = ConfigDict(from_attributes=True)  # allows ORM model ->> Pydantic conversion

    id: int
    created_at: datetime
    updated_at: datetime
<finish>]], {
            name = i(1, "Item"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1), r5 = rep(1),
            field1 = i(2, "name"), field1_r = rep(2),
            type1 = i(3, "str"), type1_opt = rep(3),
            field2 = i(4, "description"), field2_r = rep(4),
            type2 = i(5, "str | None = None"), type2_opt = rep(5),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  DEPENDENCIES                                                ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "fadep", name = "FastAPI Dependency", dscr = "Dependency injection function" },
        fmta([[
async def <name>(<params>) ->> <return_type>:  # use with Depends() in route params
    <body>
    <finish>]], {
            name = i(1, "get_current_user"),
            params = i(2, ""),
            return_type = i(3, "dict"),
            body = i(4, "pass"),
            finish = i(0),
        })
    ),

    s({ trig = "fadepdb", name = "FastAPI DB Dependency", dscr = "Async database session dependency" },
        fmta([[
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

engine = create_async_engine("<db_url>", echo=<echo>)  # echo=True logs SQL queries
async_session = async_sessionmaker(engine, expire_on_commit=False)  # prevents lazy-load errors after commit


async def get_session() ->> AsyncSession:  # type: ignore[misc]
    async with async_session() as session:
        yield session  # session is auto-closed after request; use with Depends(get_session)
<finish>]], {
            db_url = i(1, "sqlite+aiosqlite:///./db.sqlite3"),
            echo = c(2, { t("False"), t("True") }),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  AUTH                                                        ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "faauth", name = "FastAPI JWT Auth", dscr = "JWT authentication with OAuth2 password flow" },
        fmta([[
from datetime import datetime, timedelta, timezone
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from passlib.context import CryptContext

SECRET_KEY = "<secret>"  # generate with: openssl rand -hex 32
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = <expire>

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")  # handles password hashing
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="<token_url>")  # extracts Bearer token from Authorization header


def verify_password(plain: str, hashed: str) ->> bool:
    return pwd_context.verify(plain, hashed)  # compares plain text against bcrypt hash


def hash_password(password: str) ->> str:
    return pwd_context.hash(password)  # one-way hash, safe to store in DB


def create_access_token(data: dict, expires_delta: timedelta | None = None) ->> str:
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})  # JWT expiration claim
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


async def get_current_user(token: str = Depends(oauth2_scheme)):  # use as dependency on protected routes
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},  # required by OAuth2 spec
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        <sub_field>: str | None = payload.get("sub")  # "sub" claim = subject (usually username or user ID)
        if <sub_field_r> is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    <finish>
    return <sub_field_r2>
]], {
            secret = i(1, "change-me-to-a-real-secret-key"),
            expire = i(2, "30"),
            token_url = i(3, "auth/token"),
            sub_field = i(4, "username"),
            sub_field_r = rep(4), sub_field_r2 = rep(4),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  MIDDLEWARE & ERROR HANDLING                                  ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "famiddleware", name = "FastAPI Middleware", dscr = "Custom middleware" },
        fmta([[
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware


class <name>(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        <before>
        response = await call_next(request)  # calls the next middleware or route handler
        <after>
        return response
<finish>]], {
            name = i(1, "TimingMiddleware"),
            before = i(2, "# before request"),
            after = i(3, "# after request"),
            finish = i(0),
        })
    ),

    s({ trig = "facors", name = "FastAPI CORS", dscr = "CORS middleware configuration" },
        fmta([[
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[<origins>],  # list of allowed frontend origins; ["*"] allows all
    allow_credentials=True,  # allow cookies/auth headers
    allow_methods=["*"],  # allow all HTTP methods
    allow_headers=["*"],  # allow all request headers
)]], {
            origins = i(1, '"http://localhost:3000"'),
        })
    ),

    s({ trig = "faexhandler", name = "FastAPI Exception Handler", dscr = "Custom exception with handler" },
        fmta([[
from fastapi import Request
from fastapi.responses import JSONResponse


class <name>(Exception):  # raise this anywhere; FastAPI catches it via the handler below
    def __init__(self, detail: str, status_code: int = <status_code>):
        self.detail = detail
        self.status_code = status_code


@app.exception_handler(<r1>)  # registers a global handler for this exception type
async def <handler_name>(request: Request, exc: <r2>):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.detail},
    )
<finish>]], {
            name = i(1, "AppException"),
            r1 = rep(1), r2 = rep(1),
            status_code = i(2, "400"),
            handler_name = i(3, "app_exception_handler"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  BACKGROUND TASKS & WEBSOCKETS                               ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "fabgtask", name = "FastAPI Background Task", dscr = "Endpoint with background task" },
        fmta([[
from fastapi import BackgroundTasks


def <task_func>(<task_params>):  # runs in background after response is sent
    <task_body>


@<app>.post("/<path>")
async def <func_name>(<params>, background_tasks: BackgroundTasks):
    background_tasks.add_task(<task_func_r>, <task_args>)  # queued, not awaited
    return {"message": "<response_msg>"}
<finish>]], {
            task_func = i(1, "send_email"),
            task_params = i(2, "email: str, message: str"),
            task_body = i(3, "pass"),
            app = c(4, { t("app"), t("router") }),
            path = i(5, "send-notification"),
            func_name = i(6, "send_notification"),
            params = i(7, ""),
            task_func_r = rep(1),
            task_args = i(8, ""),
            response_msg = i(9, "Processing in background"),
            finish = i(0),
        })
    ),

    s({ trig = "faws", name = "FastAPI WebSocket", dscr = "WebSocket endpoint" },
        fmta([[
from fastapi import WebSocket, WebSocketDisconnect


@<app>.websocket("/<path>")  # ws://localhost:8000/<path>
async def <func_name>(websocket: WebSocket):
    await websocket.accept()  # complete the WebSocket handshake
    try:
        while True:
            data = await websocket.receive_text()  # blocks until client sends a message
            <finish>
            await websocket.send_text(f"Message: {data}")
    except WebSocketDisconnect:  # client closed the connection
        pass
]], {
            app = c(1, { t("app"), t("router") }),
            path = i(2, "ws"),
            func_name = i(3, "websocket_endpoint"),
            finish = i(0),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  TESTING                                                     ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "fatest", name = "FastAPI Test", dscr = "Test with async TestClient (httpx)" },
        fmta([[
import pytest
from httpx import ASGITransport, AsyncClient

from <app_module> import app


@pytest.fixture
async def client():
    async with AsyncClient(
        transport=ASGITransport(app=app),  # runs app in-process, no real server needed
        base_url="http://test",
    ) as ac:
        yield ac


@pytest.mark.anyio  # allows async test functions; requires anyio or pytest-asyncio
async def test_<test_name>(client: AsyncClient):
    response = await client.<method>("/<path>")
    assert response.status_code == <status_code>
    <finish>
]], {
            app_module = i(1, "app.main"),
            test_name = i(2, "get_items"),
            method = c(3, { t("get"), t("post"), t("put"), t("delete") }),
            path = i(4, "items"),
            status_code = i(5, "200"),
            finish = i(0),
        })
    ),

    s({ trig = "fatestcrud", name = "FastAPI CRUD Tests", dscr = "Full CRUD test suite" },
        fmta([[
"""Tests for <name> CRUD endpoints."""
import pytest
from httpx import ASGITransport, AsyncClient

from <app_module> import app


@pytest.fixture
async def client():
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        yield ac


@pytest.mark.anyio
async def test_create_<sn>(client: AsyncClient):
    response = await client.post("/<prefix>", json={<create_data>})
    assert response.status_code == 201
    data = response.json()
    assert "id" in data


@pytest.mark.anyio
async def test_list_<snp>(client: AsyncClient):
    response = await client.get("/<prefix_r>")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


@pytest.mark.anyio
async def test_get_<sn2>(client: AsyncClient):
    create = await client.post("/<prefix_r2>", json={<create_data_r>})
    item_id = create.json()["id"]
    response = await client.get(f"/<prefix_r3>/{item_id}")
    assert response.status_code == 200


@pytest.mark.anyio
async def test_update_<sn3>(client: AsyncClient):
    create = await client.post("/<prefix_r4>", json={<create_data_r2>})
    item_id = create.json()["id"]
    response = await client.put(f"/<prefix_r5>/{item_id}", json={<update_data>})
    assert response.status_code == 200


@pytest.mark.anyio
async def test_delete_<sn4>(client: AsyncClient):
    create = await client.post("/<prefix_r6>", json={<create_data_r3>})
    item_id = create.json()["id"]
    response = await client.delete(f"/<prefix_r7>/{item_id}")
    assert response.status_code == 204
]], {
            app_module = i(1, "app.main"),
            name = i(2, "Item"),
            sn = f(snake_case, { 2 }), sn2 = f(snake_case, { 2 }),
            sn3 = f(snake_case, { 2 }), sn4 = f(snake_case, { 2 }),
            snp = f(snake_case_plural, { 2 }),
            prefix = i(3, "items"),
            prefix_r = rep(3), prefix_r2 = rep(3), prefix_r3 = rep(3),
            prefix_r4 = rep(3), prefix_r5 = rep(3), prefix_r6 = rep(3), prefix_r7 = rep(3),
            create_data = i(4, '"name": "Test"'),
            create_data_r = rep(4), create_data_r2 = rep(4), create_data_r3 = rep(4),
            update_data = i(5, '"name": "Updated"'),
        })
    ),

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  FULL CRUD EXAMPLE                                           ║
    -- ╚══════════════════════════════════════════════════════════════╝

    s({ trig = "fafull", name = "FastAPI Full CRUD App", dscr = "Complete working CRUD app: model + schemas + routes + DB setup" },
        fmta([=[
"""
Complete CRUD API for <model>.
Run: uvicorn main:app --reload
"""
from contextlib import asynccontextmanager
from datetime import datetime

from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel, ConfigDict
from sqlalchemy import String, Text, func, select
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


# ── Database ──────────────────────────────────────────────────────

DATABASE_URL = "<db_url>"

engine = create_async_engine(DATABASE_URL, echo=True)  # echo=True logs SQL to console
async_session = async_sessionmaker(engine, expire_on_commit=False)


class Base(DeclarativeBase):  # all models inherit from this
    pass


async def get_session() ->> AsyncSession:  # type: ignore[misc]
    async with async_session() as session:
        yield session  # auto-closed when request ends


# ── Model ─────────────────────────────────────────────────────────

class <r1>(Base):
    __tablename__ = "<tablename>"  # actual table name in the database

    id: Mapped[int] = mapped_column(primary_key=True)  # auto-incrementing PK
    <field1>: Mapped[str] = mapped_column(String(<max_len>))
    <field2>: Mapped[str | None] = mapped_column(Text, nullable=True)  # nullable = optional in DB
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())  # set by DB on insert
    updated_at: Mapped[datetime] = mapped_column(server_default=func.now(), onupdate=func.now())  # set by DB on update

    def __repr__(self) ->> str:
        return f"<<<r2>(id={self.id}, <field1_r>={self.<field1_r2>})>>"


# ── Schemas ───────────────────────────────────────────────────────

class <r3>Base(BaseModel):  # shared fields for create and response
    <field1_r3>: str
    <field2_r>: str | None = None


class <r4>Create(<r5>Base):  # what the client sends to create
    pass


class <r6>Update(BaseModel):  # all optional for partial updates
    <field1_r4>: str | None = None
    <field2_r2>: str | None = None


class <r7>Response(<r8>Base):  # what the API returns
    model_config = ConfigDict(from_attributes=True)  # reads data from ORM model attributes

    id: int
    created_at: datetime
    updated_at: datetime


# ── App ───────────────────────────────────────────────────────────

@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)  # creates tables if they don't exist
    yield


app = FastAPI(title="<title>", lifespan=lifespan)


# ── Routes ────────────────────────────────────────────────────────

@app.get("/<prefix>", response_model=list[<r9>Response])
async def list_<snp>(
    skip: int = 0,  # query param for pagination offset
    limit: int = 100,  # query param for page size
    session: AsyncSession = Depends(get_session),  # injected DB session
):
    result = await session.execute(select(<r10>).offset(skip).limit(limit))
    return result.scalars().all()


@app.get("/<prefix_r>/{<sn>_id}", response_model=<r11>Response)
async def get_<sn2>(
    <sn3>_id: int,
    session: AsyncSession = Depends(get_session),
):
    obj = await session.get(<r12>, <sn4>_id)  # fetch by primary key
    if not obj:
        raise HTTPException(status_code=404, detail="<r13> not found")
    return obj


@app.post("/<prefix_r2>", response_model=<r14>Response, status_code=status.HTTP_201_CREATED)
async def create_<sn5>(
    data: <r15>Create,  # auto-validated from request JSON body
    session: AsyncSession = Depends(get_session),
):
    obj = <r16>(**data.model_dump())  # Pydantic dict ->> ORM model
    session.add(obj)
    await session.commit()
    await session.refresh(obj)  # reload to get id and timestamps from DB
    return obj


@app.put("/<prefix_r3>/{<sn6>_id}", response_model=<r17>Response)
async def update_<sn7>(
    <sn8>_id: int,
    data: <r18>Update,
    session: AsyncSession = Depends(get_session),
):
    obj = await session.get(<r19>, <sn9>_id)
    if not obj:
        raise HTTPException(status_code=404, detail="<r20> not found")
    for key, value in data.model_dump(exclude_unset=True).items():  # skip fields not in request
        setattr(obj, key, value)
    await session.commit()
    await session.refresh(obj)
    return obj


@app.delete("/<prefix_r4>/{<sn10>_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_<sn11>(
    <sn12>_id: int,
    session: AsyncSession = Depends(get_session),
):
    obj = await session.get(<r21>, <sn13>_id)
    if not obj:
        raise HTTPException(status_code=404, detail="<r22> not found")
    await session.delete(obj)
    await session.commit()
<finish>]=], {
            model = i(1, "Item"),
            r1 = rep(1), r2 = rep(1), r3 = rep(1), r4 = rep(1), r5 = rep(1),
            r6 = rep(1), r7 = rep(1), r8 = rep(1), r9 = rep(1), r10 = rep(1),
            r11 = rep(1), r12 = rep(1), r13 = rep(1), r14 = rep(1), r15 = rep(1),
            r16 = rep(1), r17 = rep(1), r18 = rep(1), r19 = rep(1), r20 = rep(1),
            r21 = rep(1), r22 = rep(1),
            db_url = i(2, "sqlite+aiosqlite:///./db.sqlite3"),
            tablename = f(snake_case_plural, { 1 }),
            field1 = i(3, "name"), field1_r = rep(3), field1_r2 = rep(3), field1_r3 = rep(3), field1_r4 = rep(3),
            max_len = i(4, "255"),
            field2 = i(5, "description"), field2_r = rep(5), field2_r2 = rep(5),
            title = i(6, "My API"),
            prefix = i(7, "items"),
            prefix_r = rep(7), prefix_r2 = rep(7), prefix_r3 = rep(7), prefix_r4 = rep(7),
            sn = f(snake_case, { 1 }), sn2 = f(snake_case, { 1 }), sn3 = f(snake_case, { 1 }),
            sn4 = f(snake_case, { 1 }), sn5 = f(snake_case, { 1 }), sn6 = f(snake_case, { 1 }),
            sn7 = f(snake_case, { 1 }), sn8 = f(snake_case, { 1 }), sn9 = f(snake_case, { 1 }),
            sn10 = f(snake_case, { 1 }), sn11 = f(snake_case, { 1 }), sn12 = f(snake_case, { 1 }),
            sn13 = f(snake_case, { 1 }),
            snp = f(snake_case_plural, { 1 }),
            finish = i(0),
        })
    ),
}
