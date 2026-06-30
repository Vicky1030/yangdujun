--
-- Kingbase database dump
--

-- Dumped from database version 12.1
-- Dumped by sys_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET exclude_reserved_words = '';
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_with_oids = off;
SET default_with_rowid = off;

--
-- Name: wmsys; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS wmsys;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alert_action_log; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.alert_action_log (
    id bigint NOT NULL,
    alert_id bigint NOT NULL,
    device_id bigint,
    command character varying(64 char),
    notify_user_id bigint,
    operator character varying(64 char),
    action_note character varying(500 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: alert_action_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alert_action_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alert_action_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alert_action_log_id_seq OWNED BY public.alert_action_log.id;


--
-- Name: alert_rule; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.alert_rule (
    id bigint NOT NULL,
    rule_code character varying(64 char) NOT NULL,
    rule_name character varying(128 char) NOT NULL,
    greenhouse_id bigint,
    device_type_id bigint,
    metric_key character varying(64 char) NOT NULL,
    operator character varying(16 char) NOT NULL,
    threshold_value numeric(12,2) NOT NULL,
    duration_minutes integer DEFAULT 5 NOT NULL,
    level character varying(32 char) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    description character varying(500 char),
    deleted boolean DEFAULT false NOT NULL,
    created_by character varying(64 char),
    updated_by character varying(64 char),
    deleted_by character varying(64 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: alert_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alert_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alert_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alert_rule_id_seq OWNED BY public.alert_rule.id;


--
-- Name: app_session; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.app_session (
    token character varying(64 char) NOT NULL,
    user_id bigint NOT NULL,
    username character varying(64 char) NOT NULL,
    role_code character varying(32 char) NOT NULL,
    client_ip character varying(64 char),
    expires_at timestamp without time zone NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: app_user; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.app_user (
    id bigint NOT NULL,
    username character varying(64 char) NOT NULL,
    password_hash character varying(128 char) NOT NULL,
    role_code character varying(32 char) NOT NULL,
    phone character varying(32 char),
    email character varying(128 char),
    display_name character varying(64 char),
    avatar_url character varying(512 char),
    gender character varying(16 char),
    bio character varying(500 char),
    last_login_ip character varying(64 char),
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_by character varying(64 char),
    updated_by character varying(64 char),
    deleted_by character varying(64 char),
    deleted_at timestamp without time zone,
    allow_admin_delete boolean DEFAULT false NOT NULL
);


--
-- Name: app_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_user_id_seq OWNED BY public.app_user.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.auth_permission (
    id bigint NOT NULL,
    permission_code character varying(128 char) NOT NULL,
    permission_name character varying(128 char) NOT NULL,
    resource_type character varying(32 char) DEFAULT 'API'::varchar NOT NULL,
    resource_path character varying(255 char),
    http_method character varying(16 char),
    parent_id bigint,
    sort_order integer DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_role; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.auth_role (
    id bigint NOT NULL,
    role_code character varying(32 char) NOT NULL,
    role_name character varying(64 char) NOT NULL,
    description character varying(500 char),
    enabled boolean DEFAULT true NOT NULL,
    data_scope character varying(32 char) DEFAULT 'SELF'::varchar NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: auth_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_role_id_seq OWNED BY public.auth_role.id;


--
-- Name: auth_role_permission; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.auth_role_permission (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: auth_role_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_role_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_role_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_role_permission_id_seq OWNED BY public.auth_role_permission.id;


--
-- Name: auth_user_role; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.auth_user_role (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: auth_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_role_id_seq OWNED BY public.auth_user_role.id;


--
-- Name: device_type; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.device_type (
    id bigint NOT NULL,
    type_code character varying(64 char) NOT NULL,
    type_name character varying(128 char) NOT NULL,
    category character varying(64 char) NOT NULL,
    protocol character varying(32 char) DEFAULT 'MODBUS'::varchar NOT NULL,
    unit character varying(32 char),
    telemetry_key character varying(64 char),
    command_capable boolean DEFAULT true NOT NULL,
    description character varying(500 char),
    enabled boolean DEFAULT true NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: device_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_type_id_seq OWNED BY public.device_type.id;


--
-- Name: farmer_greenhouse_binding; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.farmer_greenhouse_binding (
    id bigint NOT NULL,
    farmer_user_id bigint NOT NULL,
    greenhouse_id bigint NOT NULL,
    assigned_by bigint,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: farmer_greenhouse_binding_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.farmer_greenhouse_binding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: farmer_greenhouse_binding_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.farmer_greenhouse_binding_id_seq OWNED BY public.farmer_greenhouse_binding.id;


--
-- Name: feedback; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.feedback (
    id bigint NOT NULL,
    user_id bigint,
    category character varying(64 char) NOT NULL,
    content character varying(1000 char) NOT NULL,
    contact character varying(128 char),
    status character varying(32 char) DEFAULT 'OPEN'::varchar NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: feedback_conversation; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.feedback_conversation (
    id bigint NOT NULL,
    farmer_user_id bigint NOT NULL,
    admin_user_id bigint NOT NULL,
    status character varying(32 char) DEFAULT 'OPEN'::varchar NOT NULL,
    last_message character varying(500 char),
    last_message_at timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: feedback_conversation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_conversation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_conversation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_conversation_id_seq OWNED BY public.feedback_conversation.id;


--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_id_seq OWNED BY public.feedback.id;


--
-- Name: feedback_message; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.feedback_message (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    sender_user_id bigint NOT NULL,
    receiver_user_id bigint NOT NULL,
    content character varying(1000 char) NOT NULL,
    read_at timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    message_type character varying(32 char) DEFAULT 'TEXT'::varchar NOT NULL,
    image_url character varying(512 char)
);


--
-- Name: feedback_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_message_id_seq OWNED BY public.feedback_message.id;


--
-- Name: greenhouse; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.greenhouse (
    id bigint NOT NULL,
    owner_user_id bigint,
    name character varying(128 char) NOT NULL,
    location character varying(255 char),
    status character varying(32 char) NOT NULL,
    area numeric(10,2) DEFAULT 0 NOT NULL,
    crop_stage character varying(64 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_by character varying(64 char),
    updated_by character varying(64 char),
    deleted_by character varying(64 char),
    deleted_at timestamp without time zone
);


--
-- Name: greenhouse_alert; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.greenhouse_alert (
    id bigint NOT NULL,
    greenhouse_id bigint NOT NULL,
    title character varying(160 char) NOT NULL,
    description character varying(500 char),
    level character varying(32 char) NOT NULL,
    status character varying(32 char) NOT NULL,
    occurred_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    resolved_at timestamp without time zone,
    device_id bigint,
    handled_by character varying(64 char),
    handle_note character varying(500 char),
    handled_at timestamp without time zone,
    rule_id bigint,
    deleted boolean DEFAULT false NOT NULL,
    created_by character varying(64 char),
    updated_by character varying(64 char),
    deleted_by character varying(64 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: greenhouse_alert_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.greenhouse_alert_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: greenhouse_alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.greenhouse_alert_id_seq OWNED BY public.greenhouse_alert.id;


--
-- Name: greenhouse_device; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.greenhouse_device (
    id bigint NOT NULL,
    greenhouse_id bigint NOT NULL,
    name character varying(128 char) NOT NULL,
    category character varying(64 char) NOT NULL,
    status character varying(32 char) NOT NULL,
    location character varying(255 char),
    auto_mode boolean DEFAULT false NOT NULL,
    health_score integer DEFAULT 100 NOT NULL,
    last_command character varying(64 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    device_type_id bigint,
    manufacturer character varying(128 char),
    model character varying(128 char),
    serial_no character varying(128 char),
    protocol character varying(32 char) DEFAULT 'MODBUS'::varchar,
    deleted boolean DEFAULT false NOT NULL,
    created_by character varying(64 char),
    updated_by character varying(64 char),
    deleted_by character varying(64 char),
    deleted_at timestamp without time zone,
    remark character varying(500 char)
);


--
-- Name: greenhouse_device_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.greenhouse_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: greenhouse_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.greenhouse_device_id_seq OWNED BY public.greenhouse_device.id;


--
-- Name: greenhouse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.greenhouse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: greenhouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.greenhouse_id_seq OWNED BY public.greenhouse.id;


--
-- Name: operation_log; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.operation_log (
    id bigint NOT NULL,
    trace_id character varying(64 char),
    username character varying(64 char),
    client_ip character varying(64 char),
    module_name character varying(64 char),
    action_name character varying(128 char),
    request_uri character varying(255 char),
    http_method character varying(16 char),
    success boolean NOT NULL,
    elapsed_ms bigint,
    message character varying(500 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id bigint,
    risk_level character varying(32 char) DEFAULT 'LOW'::varchar NOT NULL,
    request_digest character varying(128 char)
);


--
-- Name: operation_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.operation_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operation_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.operation_log_id_seq OWNED BY public.operation_log.id;


--
-- Name: production_batch; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.production_batch (
    id bigint NOT NULL,
    batch_no character varying(64 char) NOT NULL,
    greenhouse_id bigint NOT NULL,
    batch_name character varying(128 char) NOT NULL,
    crop_name character varying(64 char) DEFAULT '羊肚菌'::varchar NOT NULL,
    status character varying(32 char) DEFAULT 'RUNNING'::varchar NOT NULL,
    started_at date NOT NULL,
    expected_harvest_at date,
    actual_harvest_at date,
    summary character varying(500 char),
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: production_batch_event; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.production_batch_event (
    id bigint NOT NULL,
    batch_id bigint NOT NULL,
    event_code character varying(64 char) NOT NULL,
    event_title character varying(128 char) NOT NULL,
    event_status character varying(32 char) DEFAULT 'DONE'::varchar NOT NULL,
    operator character varying(64 char),
    event_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description character varying(500 char),
    block_hash character varying(128 char),
    previous_hash character varying(128 char),
    sort_order integer DEFAULT 0 NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: production_batch_event_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.production_batch_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: production_batch_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.production_batch_event_id_seq OWNED BY public.production_batch_event.id;


--
-- Name: production_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.production_batch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: production_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.production_batch_id_seq OWNED BY public.production_batch.id;


--
-- Name: sys_dict_item; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.sys_dict_item (
    id bigint NOT NULL,
    type_code character varying(64 char) NOT NULL,
    item_code character varying(64 char) NOT NULL,
    item_name character varying(128 char) NOT NULL,
    item_value character varying(255 char),
    tag_type character varying(32 char),
    enabled boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    remark character varying(500 char),
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: sys_dict_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_dict_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_dict_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_dict_item_id_seq OWNED BY public.sys_dict_item.id;


--
-- Name: sys_dict_type; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.sys_dict_type (
    id bigint NOT NULL,
    type_code character varying(64 char) NOT NULL,
    type_name character varying(128 char) NOT NULL,
    description character varying(500 char),
    enabled boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: sys_dict_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_dict_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_dict_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_dict_type_id_seq OWNED BY public.sys_dict_type.id;


--
-- Name: sys_permission; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.sys_permission (
    id bigint NOT NULL,
    permission_code character varying(128 char) NOT NULL,
    permission_name character varying(128 char) NOT NULL,
    resource_type character varying(32 char) DEFAULT 'API'::varchar NOT NULL,
    resource_path character varying(255 char),
    http_method character varying(16 char),
    parent_id bigint,
    sort_order integer DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: sys_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_permission_id_seq OWNED BY public.sys_permission.id;


--
-- Name: sys_role; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.sys_role (
    id bigint NOT NULL,
    role_code character varying(32 char) NOT NULL,
    role_name character varying(64 char) NOT NULL,
    description character varying(500 char),
    enabled boolean DEFAULT true NOT NULL,
    data_scope character varying(32 char) DEFAULT 'SELF'::varchar NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: sys_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_role_id_seq OWNED BY public.sys_role.id;


--
-- Name: sys_user; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.sys_user (
    id bigint NOT NULL,
    username character varying(64 char) NOT NULL,
    password_hash character varying(128 char) NOT NULL,
    role_code character varying(32 char) NOT NULL,
    phone character varying(32 char),
    email character varying(128 char),
    display_name character varying(64 char),
    avatar_url character varying(512 char),
    gender character varying(16 char),
    bio character varying(500 char),
    last_login_ip character varying(64 char),
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: sys_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_user_id_seq OWNED BY public.sys_user.id;


--
-- Name: telemetry_snapshot; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.telemetry_snapshot (
    id bigint NOT NULL,
    greenhouse_id bigint NOT NULL,
    temperature numeric(6,2) NOT NULL,
    humidity numeric(6,2) NOT NULL,
    light_lux integer NOT NULL,
    co2_ppm integer NOT NULL,
    soil_moisture numeric(6,2) NOT NULL,
    collected_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: telemetry_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.telemetry_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: telemetry_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.telemetry_snapshot_id_seq OWNED BY public.telemetry_snapshot.id;


--
-- Name: traceability_record; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.traceability_record (
    id bigint NOT NULL,
    greenhouse_id bigint NOT NULL,
    batch_no character varying(64 char) NOT NULL,
    operation character varying(128 char) NOT NULL,
    operator character varying(64 char) NOT NULL,
    operation_date date NOT NULL,
    note character varying(500 char),
    deleted boolean DEFAULT false NOT NULL,
    created_by character varying(64 char),
    updated_by character varying(64 char),
    deleted_by character varying(64 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: traceability_record_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.traceability_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: traceability_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.traceability_record_id_seq OWNED BY public.traceability_record.id;


--
-- Name: v_greenhouse_realtime; Type: VIEW; Schema: public; Owner: -
--

SET escape = off;


CREATE FORCE VIEW public.v_greenhouse_realtime AS
 SELECT g.id,
    g.name,
    g.status,
    t.temperature,
    t.humidity,
    t.light_lux,
    t.co2_ppm,
    t.soil_moisture,
    t.collected_at
   FROM (public.greenhouse g
     LEFT JOIN public.telemetry_snapshot t ON ((t.id = ( SELECT ts.id
           FROM public.telemetry_snapshot ts
          WHERE (ts.greenhouse_id = g.id)
          ORDER BY ts.collected_at DESC
         LIMIT 1))))
  WHERE (g.deleted = false);


--
-- Name: verification_code; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.verification_code (
    id bigint NOT NULL,
    receiver character varying(128 char) NOT NULL,
    scene character varying(32 char) NOT NULL,
    code character varying(12 char) NOT NULL,
    used boolean DEFAULT false NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    client_ip character varying(64 char),
    delivery_status character varying(32 char) DEFAULT 'PENDING'::varchar NOT NULL,
    delivery_message character varying(500 char),
    sent_at timestamp without time zone
);


--
-- Name: verification_code_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.verification_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: verification_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.verification_code_id_seq OWNED BY public.verification_code.id;


--
-- Name: verification_send_log; Type: TABLE; Schema: public; Owner: -
--

SET escape = off;


CREATE TABLE public.verification_send_log (
    id bigint NOT NULL,
    receiver character varying(128 char) NOT NULL,
    scene character varying(32 char) NOT NULL,
    channel character varying(32 char) DEFAULT 'EMAIL'::varchar NOT NULL,
    client_ip character varying(64 char),
    delivery_mode character varying(32 char) NOT NULL,
    status character varying(32 char) NOT NULL,
    retry_count integer DEFAULT 0 NOT NULL,
    provider_message character varying(500 char),
    error_message character varying(1000 char),
    request_trace_id character varying(64 char),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: verification_send_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.verification_send_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: verification_send_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.verification_send_log_id_seq OWNED BY public.verification_send_log.id;


--
-- Name: alert_action_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_action_log ALTER COLUMN id SET DEFAULT nextval('public.alert_action_log_id_seq'::regclass);


--
-- Name: alert_rule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rule ALTER COLUMN id SET DEFAULT nextval('public.alert_rule_id_seq'::regclass);


--
-- Name: app_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user ALTER COLUMN id SET DEFAULT nextval('public.app_user_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role ALTER COLUMN id SET DEFAULT nextval('public.auth_role_id_seq'::regclass);


--
-- Name: auth_role_permission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_role_permission_id_seq'::regclass);


--
-- Name: auth_user_role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_role ALTER COLUMN id SET DEFAULT nextval('public.auth_user_role_id_seq'::regclass);


--
-- Name: device_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_type ALTER COLUMN id SET DEFAULT nextval('public.device_type_id_seq'::regclass);


--
-- Name: farmer_greenhouse_binding id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmer_greenhouse_binding ALTER COLUMN id SET DEFAULT nextval('public.farmer_greenhouse_binding_id_seq'::regclass);


--
-- Name: feedback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback ALTER COLUMN id SET DEFAULT nextval('public.feedback_id_seq'::regclass);


--
-- Name: feedback_conversation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_conversation ALTER COLUMN id SET DEFAULT nextval('public.feedback_conversation_id_seq'::regclass);


--
-- Name: feedback_message id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_message ALTER COLUMN id SET DEFAULT nextval('public.feedback_message_id_seq'::regclass);


--
-- Name: greenhouse id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse ALTER COLUMN id SET DEFAULT nextval('public.greenhouse_id_seq'::regclass);


--
-- Name: greenhouse_alert id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_alert ALTER COLUMN id SET DEFAULT nextval('public.greenhouse_alert_id_seq'::regclass);


--
-- Name: greenhouse_device id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_device ALTER COLUMN id SET DEFAULT nextval('public.greenhouse_device_id_seq'::regclass);


--
-- Name: operation_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operation_log ALTER COLUMN id SET DEFAULT nextval('public.operation_log_id_seq'::regclass);


--
-- Name: production_batch id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.production_batch ALTER COLUMN id SET DEFAULT nextval('public.production_batch_id_seq'::regclass);


--
-- Name: production_batch_event id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.production_batch_event ALTER COLUMN id SET DEFAULT nextval('public.production_batch_event_id_seq'::regclass);


--
-- Name: sys_dict_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_dict_item ALTER COLUMN id SET DEFAULT nextval('public.sys_dict_item_id_seq'::regclass);


--
-- Name: sys_dict_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_dict_type ALTER COLUMN id SET DEFAULT nextval('public.sys_dict_type_id_seq'::regclass);


--
-- Name: sys_permission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_permission ALTER COLUMN id SET DEFAULT nextval('public.sys_permission_id_seq'::regclass);


--
-- Name: sys_role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_role ALTER COLUMN id SET DEFAULT nextval('public.sys_role_id_seq'::regclass);


--
-- Name: sys_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_user ALTER COLUMN id SET DEFAULT nextval('public.sys_user_id_seq'::regclass);


--
-- Name: telemetry_snapshot id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telemetry_snapshot ALTER COLUMN id SET DEFAULT nextval('public.telemetry_snapshot_id_seq'::regclass);


--
-- Name: traceability_record id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traceability_record ALTER COLUMN id SET DEFAULT nextval('public.traceability_record_id_seq'::regclass);


--
-- Name: verification_code id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_code ALTER COLUMN id SET DEFAULT nextval('public.verification_code_id_seq'::regclass);


--
-- Name: verification_send_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_send_log ALTER COLUMN id SET DEFAULT nextval('public.verification_send_log_id_seq'::regclass);


--
-- Data for Name: alert_action_log; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: alert_rule; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.alert_rule (id, rule_code, rule_name, greenhouse_id, device_type_id, metric_key, operator, threshold_value, duration_minutes, level, enabled, description, deleted, created_by, updated_by, deleted_by, created_at, updated_at, deleted_at) VALUES (1, 'HUMIDITY_HIGH_A01', '湿度持续偏高', NULL, NULL, 'humidity', 'GT', 88.00, 8, 'WARNING', true, '连续多分钟超过湿度上限时触发', false, NULL, NULL, NULL, '2026-06-29 13:44:46.315016', '2026-06-29 13:44:46.315016', NULL);
INSERT INTO public.alert_rule (id, rule_code, rule_name, greenhouse_id, device_type_id, metric_key, operator, threshold_value, duration_minutes, level, enabled, description, deleted, created_by, updated_by, deleted_by, created_at, updated_at, deleted_at) VALUES (2, 'CO2_HIGH_A01', 'CO2 浓度偏高', NULL, NULL, 'co2_ppm', 'GT', 1200.00, 5, 'CRITICAL', true, 'CO2 浓度过高时提醒通风', false, NULL, NULL, NULL, '2026-06-29 13:44:46.330867', '2026-06-29 13:44:46.330867', NULL);


--
-- Data for Name: app_session; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('aeb7b5fd-9889-413c-ac7a-f00988cee8f8', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 03:12:02.943530', false, '2026-06-29 03:12:02.944787');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('38e766d2-17a8-429e-9f99-9ccaa8568ee6', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 03:12:39.855297', false, '2026-06-29 03:12:39.856046');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('a1aa3171-75b7-4116-9fb2-da81ac2c619c', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 03:12:39.862297', false, '2026-06-29 03:12:39.863524');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('391e3e4a-daa2-473e-bb5f-cdec56b6a465', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 03:18:24.619115', false, '2026-06-29 03:18:24.626213');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('5cb9a6ae-f78d-494d-9b68-969679eb8517', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 03:18:24.624114', false, '2026-06-29 03:18:24.627533');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('626c9a02-3f7c-4f2f-9bb1-a9c01747332d', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 03:18:24.626497', false, '2026-06-29 03:18:24.628220');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('f13923da-e8b5-4e14-a305-77a539784cf3', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 03:20:57.509942', false, '2026-06-29 03:20:57.512153');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('4d7bd40a-ca9d-47ab-919b-d8b19022687d', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 03:20:57.509942', false, '2026-06-29 03:20:57.512823');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('c498ec24-86fd-43bf-b71e-1e5e20b6b402', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 03:21:57.827965', false, '2026-06-29 03:21:57.828309');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('f834754b-2160-40f6-9f03-ca7a2b880599', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 12:36:54.237928', false, '2026-06-29 12:36:54.239182');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('e7ca829e-1d11-4b2a-8c70-da621933f164', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 12:39:52.525526', false, '2026-06-29 12:39:52.526097');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('abed04a8-8dc4-4614-8e75-33f78f6842d9', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 13:04:36.631666', false, '2026-06-29 13:04:36.633516');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('af1a9ae9-558e-43db-8b9a-df56343c9577', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 13:07:43.671159', false, '2026-06-29 13:07:43.672594');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('c66c9a28-8677-42fd-9a24-6341231745cf', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 13:14:05.972966', false, '2026-06-29 13:14:05.974178');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('48f1a408-f90f-4ee6-ae28-53286295da23', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 13:45:24.640326', false, '2026-06-29 13:45:24.641996');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('80afd7c6-d123-4c96-83ff-aa5432188a5c', 4, '20246144', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 16:35:29.442819', false, '2026-06-29 16:35:33.766320');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('0b5de049-3bce-4dbc-8902-afe5cbff48c4', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 16:40:01.826426', false, '2026-06-29 16:40:01.827793');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('370f0ca7-3355-4b37-bd18-5e36811b2560', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 16:46:47.661190', false, '2026-06-29 16:46:47.661953');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('445ca722-0f68-4a32-8790-94e06e6d6072', 3, 'CM+', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 16:49:27.825963', false, '2026-06-29 16:49:27.831280');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('634f0882-fa3d-49a5-a839-cce520a0c062', 4, '20246144', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 16:59:56.956913', false, '2026-06-29 17:00:01.279335');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('8817cdbd-1113-4f46-9005-a0d45025e6b4', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 18:40:09.191927', false, '2026-06-29 18:40:13.533962');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('e5b8891c-b0c1-468f-83c4-58fbacfb4100', 4, '20246144', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 18:55:01.058875', false, '2026-06-29 18:55:05.403783');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('3c17e2b4-2f66-4da2-aaeb-64c69077e499', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 18:55:23.726692', false, '2026-06-29 18:55:28.155459');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('3276c842-bea3-4d3f-a1a4-8ee84e6cc285', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 18:55:32.722269', false, '2026-06-29 18:55:32.722797');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('e106d334-55ae-4184-b68b-4389361070b3', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 18:55:32.965705', false, '2026-06-29 18:55:32.966937');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('633d4bec-d45e-4d34-9ad0-01d1bd061bc5', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 18:55:58.128504', false, '2026-06-29 18:55:58.129687');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('24bc0659-5d0d-42b6-806d-4026afa4db72', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 18:56:19.246643', false, '2026-06-29 18:56:19.247247');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('663bde65-d93e-4ae9-8a54-827e5c85ac97', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 18:56:57.557064', false, '2026-06-29 18:56:57.558240');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('b7d47aee-9939-4a8f-8d92-def811718f41', 3, 'CM+', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 19:02:35.460523', false, '2026-06-29 19:02:35.461051');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('78f6933b-f88e-4184-b7bb-0d1ef513c64f', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 19:03:49.817384', false, '2026-06-29 19:03:49.818140');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('b96d2485-b8e5-45a9-bbee-b84dd7015cbb', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 19:06:59.958769', false, '2026-06-29 19:06:59.959936');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('a6efd7a9-10be-4f67-9e66-5290f44e1c67', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 19:07:10.761275', false, '2026-06-29 19:07:10.761835');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('668e1ee6-3d4b-48eb-8cf7-6fb6cbd48e4f', 4, '20246144', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 19:08:09.339307', false, '2026-06-29 19:08:09.340327');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('1217bbaf-cac3-41d7-a8e3-e372984b94e1', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 19:08:37.670066', false, '2026-06-29 19:08:37.670869');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('fa24db8f-ac40-4151-83fe-40b10bf68e1b', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 19:09:52.448874', false, '2026-06-29 19:09:52.449741');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('85d28044-c96d-48eb-95cb-9cea4b63145a', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 19:11:32.868288', false, '2026-06-29 19:11:32.868951');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('61971791-8f76-4e90-9fff-a3aed989b443', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 19:25:08.142213', false, '2026-06-29 19:25:08.143386');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('e7217e27-bd01-4203-aca3-9bbde4b0a8f9', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 19:32:41.275325', false, '2026-06-29 19:32:41.275770');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('9b4c41d9-55d3-4aa5-96b6-caa9f05ed5bf', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 23:08:49.958110', false, '2026-06-29 23:08:49.959646');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('3b3f4bc8-e57f-43e7-84f6-c6373f6305b7', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 23:08:50.219831', false, '2026-06-29 23:08:50.220081');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('fe1940aa-d8e7-49d3-90b6-07a203a1ed97', 2, 'admin', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-06-30 23:28:11.725251', false, '2026-06-29 23:28:11.726231');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('99530f43-250e-417c-bfd5-65327a261451', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-06-30 23:48:54.904972', false, '2026-06-29 23:48:54.905597');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('5d0aac08-47b8-4f12-a87a-1f09318cf4db', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 00:51:52.887187', false, '2026-06-30 00:51:52.891680');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('e73cf314-9677-45b0-94b5-0e3b05bc0196', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-07-01 00:51:53.215116', false, '2026-06-30 00:51:53.217234');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('a89ee6f2-8bed-41d4-8eeb-2e4fdab5cec9', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 00:52:26.318242', false, '2026-06-30 00:52:26.319783');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('3e82cf73-d47d-434a-abeb-dfb4146b21b8', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-07-01 00:52:26.438193', false, '2026-06-30 00:52:26.441629');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('72792dbe-d2a4-47e8-9657-6e39692da888', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-07-01 00:53:29.138285', false, '2026-06-30 00:53:29.146002');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('0d170cb2-4cf9-4924-82fb-f88b2843884d', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 01:03:26.498226', false, '2026-06-30 01:03:26.501130');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('d4ff0f70-c0b5-480e-905b-11921e4c6866', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-07-01 01:03:26.705367', false, '2026-06-30 01:03:26.712891');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('2cb1f726-8fe8-4620-bfa9-4609dbb5f2fa', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-07-01 01:03:44.510811', false, '2026-06-30 01:03:44.512240');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('6c7e67ab-d341-4656-b1ec-c6c2440a5062', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 01:07:18.442256', false, '2026-06-30 01:07:18.443647');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('273aec8e-4a78-4d9e-ad20-a449937e359c', 1, 'farmer001', 'FARMER', '0:0:0:0:0:0:0:1', '2026-07-01 01:11:05.718962', false, '2026-06-30 01:11:05.719968');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('6cab05ab-4d3a-41d7-94ae-aab4e10f096a', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 01:15:00.234645', false, '2026-06-30 01:15:00.235384');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('66c7789b-9ace-4966-8464-6b51c0f680ce', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 01:15:27.385090', false, '2026-06-30 01:15:27.389061');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('f7e1413c-c8dd-40c7-ae54-e41601d196a7', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 09:15:02.000026', false, '2026-06-30 09:15:02.001743');
INSERT INTO public.app_session (token, user_id, username, role_code, client_ip, expires_at, revoked, created_at) VALUES ('fc8bfc62-08ec-4a02-b609-330b056c41e3', 2, 'admin1', 'ADMIN', '0:0:0:0:0:0:0:1', '2026-07-01 09:15:37.120808', false, '2026-06-30 09:15:37.122144');


--
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.app_user (id, username, password_hash, role_code, phone, email, display_name, avatar_url, gender, bio, last_login_ip, enabled, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at, allow_admin_delete) VALUES (2, 'admin1', '{bcrypt}$2a$10$YiJYr.jyw.Y3w8JkBkyZdefzJ1WcoIsZ32HIoFl/vv5Kweu9S2A.O', 'ADMIN', '13800000000', 'admin1@example.com', NULL, '/avatars/male_admin.png', 'UNKNOWN', NULL, '0:0:0:0:0:0:0:1', true, '2026-06-25 02:02:29.745002', '2026-06-30 09:15:37.120482', false, NULL, NULL, NULL, NULL, false);
INSERT INTO public.app_user (id, username, password_hash, role_code, phone, email, display_name, avatar_url, gender, bio, last_login_ip, enabled, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at, allow_admin_delete) VALUES (3, 'CM+', '{bcrypt}$2a$10$padfy0HjLfa4OO2FjmTBW.tG/QkUN5nJC0EmYnWGCHyGKbR8DhCrW', 'FARMER', '15642662203', 'CHMgGa@163.com', 'CM+', '/avatars/female_farmer.png', 'FEMALE', NULL, '0:0:0:0:0:0:0:1', true, '2026-06-26 21:07:31.212613', '2026-06-30 09:14:07.664043', false, NULL, NULL, NULL, NULL, false);
INSERT INTO public.app_user (id, username, password_hash, role_code, phone, email, display_name, avatar_url, gender, bio, last_login_ip, enabled, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at, allow_admin_delete) VALUES (4, '20246144', '{bcrypt}$2a$10$334F3oLm8rBbU8NH16JfR.FH2D1CXR0i/wzbp8Y4c4Y.vdPdN3dmm', 'FARMER', '13705025298', '13705025298@163.com', '20246144', '/avatars/male_farmer.jpg', 'UNKNOWN', NULL, '0:0:0:0:0:0:0:1', true, '2026-06-28 15:15:57.642407', '2026-06-30 09:14:07.664043', false, NULL, NULL, NULL, NULL, false);
INSERT INTO public.app_user (id, username, password_hash, role_code, phone, email, display_name, avatar_url, gender, bio, last_login_ip, enabled, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at, allow_admin_delete) VALUES (5, 'admin2', '{bcrypt}$2a$10$N./ffwMWO5eTnOwS2ovc8e3mNikOIS4KyRqtwPy.kw8A0WFOLWyRy', 'ADMIN', '13800000002', 'admin2@example.com', NULL, '/avatars/male_admin.png', 'MALE', NULL, NULL, true, '2026-06-30 01:10:22.762795', '2026-06-30 09:14:07.664043', false, 'admin', NULL, NULL, NULL, false);
INSERT INTO public.app_user (id, username, password_hash, role_code, phone, email, display_name, avatar_url, gender, bio, last_login_ip, enabled, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at, allow_admin_delete) VALUES (1, 'farmer001', '{bcrypt}$2a$10$xxcim.ZrXOSTRe2VLc80mOI2PreHDYAQCAZFJrdmgkAgWUCPgZYOa', 'FARMER', '13900000001', 'farmer001@example.com', '示范农户', '/avatars/male_farmer.jpg', 'MALE', '负责 A01 大棚日常巡检和出菇期管理', '0:0:0:0:0:0:0:1', true, '2026-06-25 02:02:29.636465', '2026-06-30 09:14:07.664043', false, NULL, NULL, NULL, NULL, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.auth_permission (id, permission_code, permission_name, resource_type, resource_path, http_method, parent_id, sort_order, enabled, deleted, created_at, updated_at, deleted_at) VALUES (1, 'greenhouse:manage', '大棚管理', 'API', '/api/v1/greenhouses/**', '*', NULL, 10, true, false, '2026-06-29 13:44:45.998297', '2026-06-29 13:44:45.998297', NULL);
INSERT INTO public.auth_permission (id, permission_code, permission_name, resource_type, resource_path, http_method, parent_id, sort_order, enabled, deleted, created_at, updated_at, deleted_at) VALUES (2, 'device:manage', '设备管理', 'API', '/api/v1/greenhouses/devices/**', '*', NULL, 20, true, false, '2026-06-29 13:44:46.008488', '2026-06-29 13:44:46.008488', NULL);
INSERT INTO public.auth_permission (id, permission_code, permission_name, resource_type, resource_path, http_method, parent_id, sort_order, enabled, deleted, created_at, updated_at, deleted_at) VALUES (3, 'alert:handle', '告警处理', 'API', '/api/v1/greenhouses/alerts/**', '*', NULL, 30, true, false, '2026-06-29 13:44:46.090006', '2026-06-29 13:44:46.090006', NULL);
INSERT INTO public.auth_permission (id, permission_code, permission_name, resource_type, resource_path, http_method, parent_id, sort_order, enabled, deleted, created_at, updated_at, deleted_at) VALUES (4, 'audit:view', '审计日志查看', 'API', '/api/v1/users/operation-logs', 'GET', NULL, 40, true, false, '2026-06-29 13:44:46.093741', '2026-06-29 13:44:46.093741', NULL);
INSERT INTO public.auth_permission (id, permission_code, permission_name, resource_type, resource_path, http_method, parent_id, sort_order, enabled, deleted, created_at, updated_at, deleted_at) VALUES (5, 'farmer:workbench', '农户工作台', 'MENU', '/farmer', 'GET', NULL, 50, true, false, '2026-06-29 13:44:46.097688', '2026-06-29 13:44:46.097688', NULL);


--
-- Data for Name: auth_role; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.auth_role (id, role_code, role_name, description, enabled, data_scope, deleted, created_at, updated_at, deleted_at) VALUES (1, 'ADMIN', '系统管理员', '拥有用户、大棚、设备、告警和反馈管理权限', true, 'ALL', false, '2026-06-29 13:44:45.857152', '2026-06-29 13:44:45.857152', NULL);
INSERT INTO public.auth_role (id, role_code, role_name, description, enabled, data_scope, deleted, created_at, updated_at, deleted_at) VALUES (2, 'FARMER', '农户', '查看本人绑定大棚、设备、告警和反馈消息', true, 'SELF', false, '2026-06-29 13:44:45.864512', '2026-06-29 13:44:45.864512', NULL);


--
-- Data for Name: auth_role_permission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.auth_role_permission (id, role_id, permission_id, created_at) VALUES (1, 1, 1, '2026-06-29 13:44:46.102315');
INSERT INTO public.auth_role_permission (id, role_id, permission_id, created_at) VALUES (2, 1, 2, '2026-06-29 13:44:46.102315');
INSERT INTO public.auth_role_permission (id, role_id, permission_id, created_at) VALUES (3, 1, 3, '2026-06-29 13:44:46.102315');
INSERT INTO public.auth_role_permission (id, role_id, permission_id, created_at) VALUES (4, 1, 4, '2026-06-29 13:44:46.102315');
INSERT INTO public.auth_role_permission (id, role_id, permission_id, created_at) VALUES (5, 1, 5, '2026-06-29 13:44:46.102315');
INSERT INTO public.auth_role_permission (id, role_id, permission_id, created_at) VALUES (6, 2, 5, '2026-06-29 13:44:46.118761');


--
-- Data for Name: auth_user_role; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.auth_user_role (id, user_id, role_id, created_at) VALUES (1, 1, 2, '2026-06-29 13:44:46.433764');
INSERT INTO public.auth_user_role (id, user_id, role_id, created_at) VALUES (3, 4, 2, '2026-06-29 13:44:46.930365');
INSERT INTO public.auth_user_role (id, user_id, role_id, created_at) VALUES (4, 3, 2, '2026-06-29 13:44:46.930365');
INSERT INTO public.auth_user_role (id, user_id, role_id, created_at) VALUES (6, 5, 1, '2026-06-30 01:10:37.702082');
INSERT INTO public.auth_user_role (id, user_id, role_id, created_at) VALUES (7, 2, 1, '2026-06-30 01:10:44.804350');


--
-- Data for Name: device_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.device_type (id, type_code, type_name, category, protocol, unit, telemetry_key, command_capable, description, enabled, deleted, created_at, updated_at, deleted_at) VALUES (1, 'VENTILATION_FAN', '循环风机组', '通风', 'MODBUS', NULL, 'wind', true, '用于棚内通风换气与空气循环', true, false, '2026-06-29 13:44:46.218022', '2026-06-29 13:44:46.218022', NULL);
INSERT INTO public.device_type (id, type_code, type_name, category, protocol, unit, telemetry_key, command_capable, description, enabled, deleted, created_at, updated_at, deleted_at) VALUES (2, 'HUMIDIFIER', '雾化加湿器', '加湿', 'MODBUS', '%', 'humidity', true, '用于维持羊肚菌生长湿度', true, false, '2026-06-29 13:44:46.224580', '2026-06-29 13:44:46.224580', NULL);
INSERT INTO public.device_type (id, type_code, type_name, category, protocol, unit, telemetry_key, command_capable, description, enabled, deleted, created_at, updated_at, deleted_at) VALUES (3, 'CO2_SENSOR', 'CO2 传感器', '环境传感器', 'MODBUS', 'ppm', 'co2_ppm', false, '采集棚内 CO2 浓度', true, false, '2026-06-29 13:44:46.307065', '2026-06-29 13:44:46.307065', NULL);
INSERT INTO public.device_type (id, type_code, type_name, category, protocol, unit, telemetry_key, command_capable, description, enabled, deleted, created_at, updated_at, deleted_at) VALUES (4, 'IRRIGATION_PUMP', '灌溉水泵', '灌溉', 'MODBUS', NULL, 'soil_moisture', true, '用于土壤和基质补水', true, false, '2026-06-29 13:44:46.311152', '2026-06-29 13:44:46.311152', NULL);


--
-- Data for Name: farmer_greenhouse_binding; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.farmer_greenhouse_binding (id, farmer_user_id, greenhouse_id, assigned_by, assigned_at, deleted, deleted_at) VALUES (1, 3, 3, NULL, '2026-06-29 21:02:06.921685', false, NULL);
INSERT INTO public.farmer_greenhouse_binding (id, farmer_user_id, greenhouse_id, assigned_by, assigned_at, deleted, deleted_at) VALUES (2, 1, 5, NULL, '2026-06-29 21:02:06.921685', false, NULL);
INSERT INTO public.farmer_greenhouse_binding (id, farmer_user_id, greenhouse_id, assigned_by, assigned_at, deleted, deleted_at) VALUES (3, 1, 1, NULL, '2026-06-29 21:02:06.921685', false, NULL);
INSERT INTO public.farmer_greenhouse_binding (id, farmer_user_id, greenhouse_id, assigned_by, assigned_at, deleted, deleted_at) VALUES (4, 1, 6, NULL, '2026-06-30 00:51:11.744631', false, NULL);
INSERT INTO public.farmer_greenhouse_binding (id, farmer_user_id, greenhouse_id, assigned_by, assigned_at, deleted, deleted_at) VALUES (5, 1, 7, NULL, '2026-06-30 00:51:11.744631', false, NULL);


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.feedback (id, user_id, category, content, contact, status, created_at, deleted, updated_at, deleted_at) VALUES (1, 4, '绑定大棚', '请管理员为账号 20246144 绑定大棚、设备和生产批次。', '13705025298', 'OPEN', '2026-06-29 18:55:13.823523', false, '2026-06-29 18:55:13.823523', NULL);


--
-- Data for Name: feedback_conversation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.feedback_conversation (id, farmer_user_id, admin_user_id, status, last_message, last_message_at, deleted, created_at, updated_at, deleted_at) VALUES (1, 1, 2, 'OPEN', 'A02 大棚 CO2 偏高，请协助查看通风策略。', '2026-06-30 00:32:43.106780', false, '2026-06-30 01:02:43.106780', '2026-06-30 01:02:43.106780', NULL);


--
-- Data for Name: feedback_message; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.feedback_message (id, conversation_id, sender_user_id, receiver_user_id, content, read_at, deleted, created_at, updated_at, deleted_at, message_type, image_url) VALUES (1, 1, 1, 2, 'A02 大棚 CO2 偏高，请协助查看通风策略。', NULL, false, '2026-06-30 01:02:43.123765', '2026-06-30 01:02:43.123765', NULL, 'TEXT', NULL);


--
-- Data for Name: greenhouse; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.greenhouse (id, owner_user_id, name, location, status, area, crop_stage, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at) VALUES (3, 3, '111', 'sy', 'ONLINE', 100.00, '如', '2026-06-26 21:09:18.143968', '2026-06-29 19:04:37.391348', false, NULL, NULL, NULL, NULL);
INSERT INTO public.greenhouse (id, owner_user_id, name, location, status, area, crop_stage, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at) VALUES (5, 1, 'test2', '沈阳', 'ONLINE', 100.00, '出菇期', '2026-06-29 19:07:36.407159', '2026-06-29 19:07:36.407159', false, NULL, NULL, NULL, NULL);
INSERT INTO public.greenhouse (id, owner_user_id, name, location, status, area, crop_stage, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at) VALUES (6, 1, 'A02 羊肚菌育菇大棚', '温室二区 / 东侧', 'WARNING', 360.00, '菌丝恢复期', '2026-06-30 00:51:11.725628', '2026-06-30 00:51:11.725628', false, 'system', NULL, NULL, NULL);
INSERT INTO public.greenhouse (id, owner_user_id, name, location, status, area, crop_stage, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at) VALUES (7, 1, 'A03 羊肚菌试验大棚', '温室二区 / 西侧', 'ONLINE', 300.00, '催菇期', '2026-06-30 00:51:11.742680', '2026-06-30 00:51:11.742680', false, 'system', NULL, NULL, NULL);
INSERT INTO public.greenhouse (id, owner_user_id, name, location, status, area, crop_stage, created_at, updated_at, deleted, created_by, updated_by, deleted_by, deleted_at) VALUES (1, 1, 'A01 羊肚菌智能大棚', '温室一区 / 北侧', 'ONLINE', 420.00, '出菇期', '2026-06-25 02:02:29.638563', '2026-06-29 23:27:13.474266', false, NULL, NULL, NULL, NULL);


--
-- Data for Name: greenhouse_alert; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.greenhouse_alert (id, greenhouse_id, title, description, level, status, occurred_at, resolved_at, device_id, handled_by, handle_note, handled_at, rule_id, deleted, created_by, updated_by, deleted_by, created_at, updated_at, deleted_at) VALUES (1, 1, '湿度波动偏高', '连续 8 分钟超过目标上限 3.5%，请检查加湿策略和通风设备。', 'WARNING', 'RESOLVED', '2026-06-25 02:02:29.667173', '2026-06-29 18:46:18.191878', 1, '管理员', '已确认告警，安排检查通风与加湿策略。', '2026-06-29 18:46:18.191878', 1, false, NULL, NULL, NULL, '2026-06-29 13:44:45.380063', '2026-06-29 23:27:13.476710', NULL);
INSERT INTO public.greenhouse_alert (id, greenhouse_id, title, description, level, status, occurred_at, resolved_at, device_id, handled_by, handle_note, handled_at, rule_id, deleted, created_by, updated_by, deleted_by, created_at, updated_at, deleted_at) VALUES (4, 6, 'CO2 浓度接近上限', 'A02 大棚 CO2 浓度持续升高，建议检查通风策略。', 'CRITICAL', 'OPEN', '2026-06-30 00:51:11.846420', NULL, 7, NULL, NULL, NULL, 2, false, 'system', NULL, NULL, '2026-06-30 00:51:11.846420', '2026-06-30 00:51:11.846420', NULL);
INSERT INTO public.greenhouse_alert (id, greenhouse_id, title, description, level, status, occurred_at, resolved_at, device_id, handled_by, handle_note, handled_at, rule_id, deleted, created_by, updated_by, deleted_by, created_at, updated_at, deleted_at) VALUES (5, 6, '水泵压力波动', '灌溉水泵压力波动，已安排复核。', 'WARNING', 'ACKNOWLEDGED', '2026-06-30 00:51:11.866700', NULL, 7, 'farmer001', '?????', '2026-06-30 00:52:26.517786', 1, false, 'system', NULL, NULL, '2026-06-30 00:51:11.866700', '2026-06-30 00:52:26.517786', NULL);


--
-- Data for Name: greenhouse_device; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (1, 1, '循环风机组', '通风', 'MAINTENANCE', '东侧风道', true, 67, 'STOP', '2026-06-25 02:02:29.659364', '2026-06-29 23:27:13.475677', 1, 'Kingbase IoT Lab', 'FAN-MR-2026', NULL, 'MODBUS', false, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (5, 1, '雾化加湿器', '加湿', 'RUNNING', '北侧雾化带', true, 92, NULL, '2026-06-30 00:51:11.757910', '2026-06-30 00:51:11.757910', 2, 'Kingbase IoT Lab', 'HMD-MR-2026', NULL, 'MODBUS', false, 'system', NULL, NULL, NULL, '根据湿度阈值自动补湿');
INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (6, 1, 'CO2 传感器', '环境传感器', 'RUNNING', '棚内中部', true, 98, NULL, '2026-06-30 00:51:11.769919', '2026-06-30 00:51:11.769919', 3, 'Kingbase IoT Lab', 'CO2-MR-2026', NULL, 'MODBUS', false, 'system', NULL, NULL, NULL, '每 5 分钟采集一次 CO2 浓度');
INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (7, 6, '灌溉水泵', '灌溉', 'MAINTENANCE', '西侧管线井', false, 58, NULL, '2026-06-30 00:51:11.772799', '2026-06-30 00:51:11.772799', 4, 'Kingbase IoT Lab', 'PUMP-MR-2026', NULL, 'MODBUS', false, 'system', NULL, NULL, NULL, '昨日巡检发现压力波动，待复核');
INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (8, 7, 'A03 循环风机', '通风', 'STOPPED', '南侧风道', true, 87, NULL, '2026-06-30 00:51:11.775074', '2026-06-30 00:51:11.775074', 1, 'Kingbase IoT Lab', 'FAN-MR-2026', NULL, 'MODBUS', false, 'system', NULL, NULL, NULL, '催菇期低速通风备用');
INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (9, 1, '??????-1908149991', '?????', 'STOPPED', '????', true, 100, NULL, '2026-06-30 00:52:26.471002', '2026-06-30 01:14:03.846341', NULL, NULL, NULL, NULL, 'MODBUS', true, NULL, NULL, 'system-cleanup', '2026-06-30 01:14:03.846341', '??????');
INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (10, 1, 'farmer-device-1172755837', 'test', 'STOPPED', 'test', true, 100, NULL, '2026-06-30 01:03:26.958549', '2026-06-30 01:14:03.846341', NULL, NULL, NULL, NULL, 'MODBUS', true, NULL, NULL, 'system-cleanup', '2026-06-30 01:14:03.846341', NULL);
INSERT INTO public.greenhouse_device (id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at, device_type_id, manufacturer, model, serial_no, protocol, deleted, created_by, updated_by, deleted_by, deleted_at, remark) VALUES (2, 1, '水泵', '灌溉', 'RUNNING', '基质上方', true, 96, 'ON', '2026-06-26 21:00:49.689769', '2026-06-28 16:52:32.079333', NULL, NULL, NULL, NULL, 'MODBUS', false, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: operation_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1, '8917fe7c7a954909bb5b797a6ea035b0', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-25 02:02:58.668937', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (2, 'cc78d02109f34dc59f615efc5ae82dbd', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-25 02:05:15.349168', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (3, '5c18da5e30a14d01848b620d1c3135f0', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 72, 'OK', '2026-06-25 02:07:26.878274', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (4, 'a8052333843444378a0964e1c7aea6fb', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 62, 'OK', '2026-06-25 02:10:59.522157', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (37, '22eb08437ea040a682c11d665335dd09', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-25 13:54:42.178319', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (38, '2cf2081497c64517a4d3cdaa61d6ca7c', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 93, 'OK', '2026-06-25 14:25:44.852244', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (39, '101726c833584fff99e4e7eb1550b44c', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 3, 'OK', '2026-06-25 14:26:04.097486', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (40, '1bb8f70e460d4ea590f8b77fe02d263c', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-25 14:26:04.117209', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (41, '5aa877138eb54b7e8b9a2493eb255cab', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 107, '账号或密码错误', '2026-06-25 14:26:04.196895', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (42, '56e708e7add64ba68850674fbde364b1', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 140, 'OK', '2026-06-25 14:28:03.090806', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (43, '3cc79ed7eb324c588790fd6483e4fb7e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 89, '用户名或密码错误', '2026-06-25 14:29:13.438439', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (44, 'dbbed80bc0fd40ebaf90fc982c8299be', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-25 14:29:13.795260', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (45, '6dfcb6edb5f245c188963c8db0c4720e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 3, 'OK', '2026-06-25 14:29:13.802854', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (46, '2ca2da4af04d40a1b3ea0cceedf7e3fe', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 186, 'OK', '2026-06-25 14:32:24.686083', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (47, '325f3f06148543c2be6c2ee8aef1f808', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-25 14:33:50.794646', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (48, '4694b8f1d4a4400d9e5ea1cd036f8cac', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 141, 'OK', '2026-06-25 14:34:17.490841', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (49, 'a6b7f3a72c20463ea6c5ba1559ab25df', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 79, 'OK', '2026-06-25 14:34:39.687834', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (79, 'b4082d0fe1fa4a02a58abaf8049c625e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 131, 'OK', '2026-06-25 18:26:29.470391', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (80, '8bc4bf844d2040728b3ebb3d8a9419ca', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-25 18:54:38.713038', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (81, 'e3649d36bd634e1c8fa86e772645f1fb', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/terms', 'GET', true, 0, 'OK', '2026-06-25 18:54:41.346604', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (82, '374ad7af0ff84f9689ca3268bc7eddbc', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-25 18:54:58.670499', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (83, '29a585cb728a4d50a685493d0c63712c', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/terms', 'GET', true, 0, 'OK', '2026-06-25 18:55:00.698371', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (84, '3d06a6b9524d4c67a045238a48bf4876', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 105, 'OK', '2026-06-25 18:55:15.580470', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (85, '01d3e70bf49d4e19b719b2529025d0d1', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 138, 'OK', '2026-06-25 18:55:16.084169', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (86, 'bb47fb23a75844198f4c999c2926ffb1', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-25 18:55:30.274361', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (87, 'c3d90b72330d455d86965f31430e5640', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 4, 'OK', '2026-06-25 18:55:32.646210', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (88, '2d0a45ccbfc8483d8d6937079d000178', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 2, 'OK', '2026-06-25 18:55:34.868099', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (89, '3c0fab9fa9b2416fb2d376b96763cd3f', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alerts', '/api/v1/greenhouses/alerts', 'GET', true, 2, 'OK', '2026-06-25 18:55:36.975772', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (90, 'c78bea996e1e4c809f06ff2a571236c5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 6, 'OK', '2026-06-25 18:55:40.278296', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (91, '570b7db4303f4583a9d38bd77394d2a6', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 4, 'OK', '2026-06-25 18:55:43.104564', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (92, '8ec9f5f5a911497b89ff8c7e680608b9', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-25 18:55:52.702724', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (93, '3e466ff40e084f3ca0ebe949866a0bdf', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 3, 'OK', '2026-06-25 18:56:02.454464', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (94, '3fd3a38f8c284781a14e89575a5f094c', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 12, 'OK', '2026-06-25 18:56:03.717329', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (95, 'da20b50e83f84ca3b33d46cbff9dbe29', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-25 18:58:04.085272', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (96, '3048a837daac4217b0f1fce824feef70', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-25 18:58:05.336009', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (97, '862cbe723b9f4227995abf8dc8469d75', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 12, 'OK', '2026-06-25 18:58:10.520096', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (98, '56ea7844012f42cbaa3ada738dd5d3d0', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-25 18:58:12.649190', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (99, '47d616239268419daa5c3807be5137b4', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-25 18:58:18.841462', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (100, '0d4b749481144a92a58ecc841fc7354f', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-25 18:58:34.716588', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (101, 'f9bf955c194a4398aac03315908a4558', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alerts', '/api/v1/greenhouses/alerts', 'GET', true, 1, 'OK', '2026-06-25 18:58:45.373722', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (102, '3e84ef47aa8c4d76a6ca534f153b6a49', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-25 18:59:05.631948', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (103, '84bbdbc1d5094b028b170174f68c532e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-25 18:59:08.399574', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (104, '77b7be8b290e4c33aed3b2b7aa452b59', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 13, 'OK', '2026-06-25 20:35:37.240182', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (105, '77a56379316941a19ecbf40fc883df7c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-25 20:43:45.144544', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (106, '902e3a00a0f146cba42cb40d7b1b1999', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alerts', '/api/v1/greenhouses/alerts', 'GET', true, 2, 'OK', '2026-06-25 20:43:46.281511', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (443, '4552e41c87754cccb0998d35c44977b3', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 03:22:16.951915', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (107, '44e23a5971484cd0b4d72fe682592ef3', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 8, 'OK', '2026-06-25 20:43:47.382313', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (108, 'f49038242123416ea33f438a42c08bde', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 5, 'OK', '2026-06-25 20:43:47.885286', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (109, 'e22b51f65ceb438b81774f498e38052b', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-25 20:43:49.211750', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (110, '5a13b0e18d864975bb34f891379d83ba', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-25 20:43:50.510955', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (111, '7ca4a68ba9a24ed5a39abb020d6b5e70', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 7, 'OK', '2026-06-25 20:43:52.203745', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (112, 'c9d430481fa14b2c9db5deed9197b43f', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-25 20:43:57.171720', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (113, '03b90c0d243d48deb2ebdd8e120320c4', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 25, 'OK', '2026-06-25 20:51:20.257484', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (114, '52a049fcb55f42a49d1f88758c606f0a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-25 20:54:33.139721', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (115, '38c6f9b392a14febafd2b3694368d00a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-25 20:55:19.862334', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (116, 'e1d57b8848444d8a9cc4f5c11dd319d2', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alerts', '/api/v1/greenhouses/alerts', 'GET', true, 20, 'OK', '2026-06-25 20:55:22.218455', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (117, 'dcf1428ae91d41859111bcfc7d6ba7d5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 13, 'OK', '2026-06-25 20:56:25.286627', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (118, '673892aa69ee4e3fa9938d5b71df76c8', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 4, 'OK', '2026-06-25 20:56:29.692748', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (119, '9f9976844adb41638595bd46afa7a133', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-25 20:56:30.805390', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (120, '8f85d8087ef54baf9f9fd5362717eae2', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 3, 'OK', '2026-06-25 20:56:32.051710', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (121, '7fd1df3c720c45efabc369c38fe65ce3', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-25 20:57:40.675695', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (122, 'da4b3a00525f4502b5b2bb6493f9bad9', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-25 20:57:42.994819', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (123, 'bdae25c8956d4ffeb3cf094402637250', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 7, 'OK', '2026-06-25 20:57:48.447879', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (124, '2abfedd706af492881d3acf52f7221d4', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 8, 'OK', '2026-06-25 20:57:55.006543', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (125, '19ebcb6c00974c49bc275a5e220453ef', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-25 20:58:13.727227', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (126, '5931594b8ab7480d8b545b3caf55dd7c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 57, 'OK', '2026-06-25 20:58:36.667998', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (127, 'b67d9db0308746eaa14e6900a731cc7c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 34, 'OK', '2026-06-25 21:00:41.881577', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (128, '0cfc020c4ca9423c922fee88edb12e87', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alerts', '/api/v1/greenhouses/alerts', 'GET', true, 3, 'OK', '2026-06-25 21:00:43.761447', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (129, '4a09f6e1181c4946823eb62bd6cf15fd', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-25 21:00:45.765807', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (130, '1399e9f5bab04b468648246e9abdd2af', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 5, 'OK', '2026-06-25 21:00:48.132547', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (131, 'ca634a1f8c4f400c8e2aa3c92a347b0f', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 5, 'OK', '2026-06-25 21:07:19.589067', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (132, '92509f4a950f4d618f9287a12ad83d79', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 5, 'OK', '2026-06-25 21:07:21.235894', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (133, 'fda520fe710e4c69b8ba5829912c8149', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 9, 'OK', '2026-06-25 21:16:54.830127', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (134, '390f47659c87483190e5f3526261493f', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-25 21:17:13.254580', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (135, '5179782897024a158d3a1a291036e6b2', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-25 21:24:14.655799', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (136, 'fd445e329c7044abad8b4bd86c6f3701', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 21, 'OK', '2026-06-25 21:25:17.165794', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (137, '59b8160c0f9547639ebca6215b28aa06', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 15, 'OK', '2026-06-25 21:25:19.529963', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (138, 'ea9c3725baa14b0ab4ceaba5be5ae8a7', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 116, 'OK', '2026-06-25 21:25:21.007095', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (139, '4e82d60d701c4170b9034447fd3235ed', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-25 21:25:31.116283', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (140, '721699b7a9614c418247c90741479124', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-25 21:25:31.139110', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (141, 'c7f52d6d78d042e0abe2ff3947352bc9', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-25 21:25:38.953284', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (142, '2a1e489448c948eda62b66f4572b8b61', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 6, 'OK', '2026-06-25 21:25:39.224306', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (143, 'da0090787b0542bb85f8be1d93bf913d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-25 21:25:46.890322', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (144, '71b4d8fb3fe845beb1cccc53adfa7644', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 4, 'OK', '2026-06-25 21:25:49.225415', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (145, 'c5c0562b2ac5452e92afdc0fe67af780', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-25 21:25:55.544022', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (146, 'dc4e3227dfd242539a0988813e7e2553', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 19, 'OK', '2026-06-25 21:25:58.678978', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (147, 'bf111f7e8e8642dba9e19166d0497b29', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 5, 'OK', '2026-06-25 21:26:00.170491', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (148, '00fc1eb3cb514e1d86bddcadab7424aa', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 3, 'OK', '2026-06-25 21:26:01.551368', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (149, '4d9b64fd892942ddb8ba2a7bf9cd9d99', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-25 21:26:02.756792', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (150, '7b2f8962431843a79f3c82ed3d7883f2', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-25 21:26:03.086410', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (151, '9c187ae55f9d46e79fd5d0a834ea3347', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-25 21:26:05.936677', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (152, '4608e4b17a5042cba1afc71e5e0311d2', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-25 21:26:07.620634', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (153, '395994e57bf94ac1839506b8af221bab', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-25 21:26:21.127785', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (154, '0a7ccf28fb2e47f186a0e96ccf4a81c4', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-25 21:26:21.486800', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (155, 'e0b1b4ac83074d82bdea19f142214530', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 9, 'OK', '2026-06-25 21:26:31.638907', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (156, 'e7e10d19b480428f941fb1ffc16b98e2', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 6, 'OK', '2026-06-25 21:26:34.207700', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (157, 'b38684db015b49b8b345aee7f99e2abe', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 92, 'OK', '2026-06-25 21:26:43.449476', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (158, '7f44eebe39af421396385fa7406b01b3', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-26 21:05:50.587462', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (159, 'e4fadc33d77348c896c1d9edce7c74d3', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/terms', 'GET', true, 0, 'OK', '2026-06-26 21:05:53.071921', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (160, 'fc538d65826047c889889e49901a76c1', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 803, 'OK', '2026-06-26 21:06:50.611042', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (161, '82885e2388b845a0a5a6e0966ecd4462', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'register', '/api/v1/auth/register', 'POST', true, 206, 'OK', '2026-06-26 21:07:31.388892', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (162, 'bc4ba4cbc4a2417f91cb85ec520e5f6b', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 110, 'OK', '2026-06-26 21:07:31.886715', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (163, '84eef65c4f074a3f8d0cf93307a31ca7', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 7, 'OK', '2026-06-26 21:07:48.117097', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (164, '6d3099b94ac44f578efaa53134e8ad02', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'updateProfile', '/api/v1/users/3/profile', 'PUT', true, 4, 'OK', '2026-06-26 21:08:01.701671', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (165, 'fcc7c8e1a9254ebc8821b504ca07a67a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 8, 'OK', '2026-06-26 21:08:04.109879', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (166, '89b4f95c49f8481c9076515ed3a65067', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-26 21:08:05.324433', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (167, 'c456af3738b3433e86bb990f0bf8be91', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 13, 'OK', '2026-06-26 21:08:05.607233', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (168, 'e21154129a5540d2860da501d194c72c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-26 21:08:06.037233', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (169, '5a93b2a5c9d3454cb37dae05182f64b8', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 1, 'OK', '2026-06-26 21:08:07.590845', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (170, '17fa4c3689f349baac4b693b2f644a38', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-26 21:08:08.561074', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (171, '830ec8d2979846ad82d4c6a700932fff', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 5, 'OK', '2026-06-26 21:08:10.406103', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (172, '65b10cc7dac74935a8cd04ffb16bd40d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-26 21:08:13.212533', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (173, '71f9f986892d4f7795978fcf4c3b1f97', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-26 21:08:13.543288', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (174, 'a893c17069824e6aae529e25b78f60ab', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-26 21:08:14.105866', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (175, 'e398db07a37849519038304b7abffae8', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'createGreenhouse', '/api/v1/greenhouses', 'POST', true, 10, 'OK', '2026-06-26 21:09:18.151150', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (176, '6522012e2c3542caa69c61d9c721b076', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 168, 'OK', '2026-06-26 21:09:18.545733', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (177, 'da48148589af45289df70f02f356c9bd', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 12, 'OK', '2026-06-26 21:09:28.670632', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (178, '630264a963af4500a36af9aade74355c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-26 21:09:44.293535', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (179, '146fb9aefbae40b296c3986125eda1ca', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-26 21:09:44.555253', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (180, '21510e68c0a2478fa5c4624c5e96dd75', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 2, 'OK', '2026-06-26 21:09:47.472379', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (181, '9f03995a13f246728e79b04531875779', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 7, 'OK', '2026-06-26 21:09:47.854692', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (182, '15f5022f5a664de0a540fe2c533cc42d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 3, 'OK', '2026-06-26 21:09:50.132463', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (183, 'd4f19a91bb4747b5b8bd3e4d35211c26', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-26 21:09:50.477199', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (184, '16e349fcfc2c4560bb077cff339721b8', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-26 21:09:54.993821', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (185, '467276feac7745628ca644267dfdb77d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-26 21:10:03.381346', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (186, '71e59065ba6c4567bce1ec68385a1f4e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-26 21:10:03.648330', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (187, '223baec600a6449fb16ff3a1929301cc', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-26 21:10:10.174076', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (188, '36f611e4887944848e47fc99b93bca65', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 1, 'OK', '2026-06-26 21:10:12.901217', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (189, 'e0c2fbd08004453289e1a75b544024b1', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 8, 'OK', '2026-06-26 21:57:33.896714', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (190, 'd26fde9fb2f24e4185cc0be665c0f773', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 13, 'OK', '2026-06-26 22:44:22.075252', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (223, '8af20ac3ad7747b2976ba6b6e6320adc', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 28, 'OK', '2026-06-28 14:50:46.601054', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (224, 'a4455a52221d4412bf9f592a76189c06', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 1, 'OK', '2026-06-28 14:58:24.365397', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (225, '11dbdfc1268a46a8aab29a8d76e9ce6c', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/terms', 'GET', true, 2, 'OK', '2026-06-28 14:58:30.825387', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (226, 'a150c090078c40fdbf349472a138b4f1', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 959, 'OK', '2026-06-28 15:15:00.732517', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (227, 'e40db1cd034c43218ab7366bcc566e45', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'register', '/api/v1/auth/register', 'POST', true, 170, 'OK', '2026-06-28 15:15:57.790404', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (228, 'a9cc628a49074b97ab3cc3a08f9592b5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 46, 'OK', '2026-06-28 15:15:57.923366', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (229, '5654ec9dc2c14dd0ad89048266622820', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-28 15:16:14.094903', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (230, '2a2d5d6cfcc24ee1a0983bc71ae4727b', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-28 15:16:34.847275', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (231, '025fdebb9a2248f299b8c3034f4f47e4', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-28 15:16:34.881769', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (232, '0bdc5441bd6c462a97ac9c78c1cec2f2', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 128, '用户名或密码错误', '2026-06-28 15:26:28.403302', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (233, 'a6ec95e40235425cb67801b165a49584', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 8, 'OK', '2026-06-28 15:26:33.589020', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (234, '29b3f5e55c624d4fb029cec7604ffe99', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 168, 'OK', '2026-06-28 15:26:34.313553', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (235, 'db4a2b73fb03426e925d50bf960c2aaf', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 11, 'OK', '2026-06-28 15:26:34.701490', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (236, '81906ee396014670ae23beb0a917d81c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-28 15:26:37.796750', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (237, '5b2aa9bbe22a45149b6405b5816b20af', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 5, 'OK', '2026-06-28 15:26:38.178703', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (238, '92eb6ef1cbba40b195c861c42dfc5db6', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-28 15:26:38.431613', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (239, 'd9ec7aca52224b22bb8f9080d7b0d88c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 7, 'OK', '2026-06-28 15:26:38.486010', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (240, '1d6eee1d5d05427293249c47d7410838', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-28 15:26:39.644089', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (241, '724e5fc881bb4c049bf05244b832ace0', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-28 15:26:39.676090', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (242, 'f54da7e42d9e465fb3b6195a70770359', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 13, 'OK', '2026-06-28 15:26:39.892139', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (243, 'f5eed05458854ee691fc65e4a2c4053e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 7, 'OK', '2026-06-28 15:26:40.237958', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (244, 'c6e0392367114d0488ee6d67a951c7bf', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:26:40.659474', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (245, '082702706aa84b86a21d4100ced3c7c8', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 5, 'OK', '2026-06-28 15:26:40.717108', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (246, '79c5de860c594b32b01fd3ebde3d464c', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 3, 'OK', '2026-06-28 15:26:41.578295', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (247, '016b9dda46f14b45abd66f61203a85f5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-28 15:26:42.039165', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (248, '264f10b7b4cc43b68b342b13793634b6', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 13, 'OK', '2026-06-28 15:26:42.393515', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (249, 'bcd0241ba1824642a3b9496dfefcc9aa', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 2, 'OK', '2026-06-28 15:26:43.428898', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (250, 'd6fd12d2a4e04c439265bcf421cfa5c7', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 6, 'OK', '2026-06-28 15:26:43.581301', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (251, '5ef2025a2446498ba0e064a027bffafa', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-28 15:26:44.510469', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (252, '6d483fc56a3247eaa0b96ff7c2739a7c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-28 15:26:45.311049', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (253, '4a18670e9c814b2f8e3f6ad7d1c2dfe7', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-28 15:26:45.348387', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (254, '90d877afc63c40f3b5c8e27fa4532996', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 5, 'OK', '2026-06-28 15:26:46.130052', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (255, '1d6d8c6b26014176a3e91f3711ac7071', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-28 15:26:46.165129', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (256, 'b3dbf66a7b6c4f799014ecd67d94b45e', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-28 15:26:47.658938', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (257, 'd5145784b5f344dfbe2f2c41688a9586', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-28 15:26:48.852277', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (258, 'dc9c378db1454fe7a97c118c3a5e955d', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-28 15:26:49.781088', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (259, '69d6f4ae33c04f2fad5036a1265107eb', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-28 15:26:52.573179', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (260, '3d0cc7c6e8f944538f2bfd72e513f225', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 23, 'OK', '2026-06-28 15:26:54.156231', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (261, '8dbc4395dc584ab6b0d5701d61c25beb', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 6, 'OK', '2026-06-28 15:26:57.329088', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (262, '9f162688959a488badbbfdee001762ef', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 5, 'OK', '2026-06-28 15:27:16.617748', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (263, '070b0137e1924b31b4ff16569b795a23', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 345, 'OK', '2026-06-28 15:27:19.180420', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (264, '9c6c1de12e174de4bbc37f07c1bdd8ba', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 19, 'OK', '2026-06-28 15:27:20.963522', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (265, '89287cab5a0943919b5d27479db5719a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:28:56.529956', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (266, 'e1c283b21a784328be5464fd3accb37d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-28 15:28:56.798116', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (267, 'd831bf265a5b4dbfa1a2e6a8020e3e66', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-28 15:29:04.967253', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (268, '2aaa0d2f760d430db6f5850efda601f9', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 13, 'OK', '2026-06-28 15:29:05.323010', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (269, '6236392a11b944b0a11b827fa9441598', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-28 15:29:43.072550', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (270, 'df33b85b518e4508b02c4bea15ed1125', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 35, 'OK', '2026-06-28 15:29:45.325022', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (271, '7bc36a3c82914d9bbfa852bf9d3a0c58', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:34:24.192026', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (272, 'fb544c60790747bcba871c689ec7b3a4', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-28 15:34:24.216675', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (273, '40358518624d4739b0830595c0151434', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-28 15:34:24.450809', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (274, '6b2a071312614c3f813d26780c593000', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 11, 'OK', '2026-06-28 15:34:33.671271', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (275, '474c0f2dcf7b4b9dbae72d835f20cd88', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:34:34.568190', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (276, '6e8b560c8f4f42848c6a025a7f367028', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 6, 'OK', '2026-06-28 15:34:34.644036', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (277, '045a7d12cc344c3c99487953657e6b3c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 9, 'OK', '2026-06-28 15:34:35.630721', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (278, '138711094ffa4963866283fd101910e0', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 1, 'OK', '2026-06-28 15:34:36.226205', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (279, '378525f822c44fe387b95f634d2a896f', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-28 15:34:36.774803', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (280, '4ea75d0a5e864c0fb7aa32ff94e8a7b2', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 1, 'OK', '2026-06-28 15:34:42.152115', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (281, '7420624a49bb471fa697c49cf3375fed', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-28 15:34:42.560255', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (282, 'cadf0e54d8c448ff996d8a77a577296c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:34:47.403185', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (283, '8abdf9e47b6b45db8c43671a421401b2', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-28 15:34:47.436055', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (284, '360631b5da3b4ed480843089dae3e032', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:34:48.179928', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (285, 'e0829523f0894a6e90a38118e0ccc29c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-28 15:34:48.208836', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (286, 'a9fd73a29ca94b199b83bf2558c15e58', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-28 15:34:49.790488', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (287, 'a83cafbad5dc474e8cd115af32cac197', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 10, 'OK', '2026-06-28 15:35:35.688726', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (288, 'd08fea51443043c79a0b9755fc7db799', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-28 15:35:35.715974', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (289, '3f376589064e4488ba9ad1ae83d700b8', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:35:37.549222', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (290, '4f18af666b404615be4451deb7970561', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-28 15:35:37.585079', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (291, 'd341cd5a20af4724b28b9c86e5d4479b', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-28 15:35:40.148417', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (292, '39a58c022a284522b8fae8c80d6157a5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-28 15:35:40.959744', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (293, '09bdcca9cf814c78bf982fa740b63165', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-28 15:35:40.998267', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (294, '5aa0a382e8014147916748e57e5c5804', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-28 15:35:42.260198', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (295, 'a8b27c3480314ce48e61a1cb9ca1e1ba', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:36:07.590911', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (296, '4f211366fa2a483787d2f030240e8714', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-28 15:36:07.627103', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (297, '238ba6f385ab43de8bf607c547229604', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-28 15:36:08.103659', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (298, '82bce53b690f4907a055a95d15d0fa5d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-28 15:36:08.147943', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (299, '655c716c420b42aabe8a07f1b072258a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-28 15:36:08.820066', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (300, 'd0c0cab749dd4e9d9e48e0725084b2f0', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 2, 'OK', '2026-06-28 15:36:09.648530', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (301, '699efb61c72f4d8eb7781701fb0740f3', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-28 15:36:11.878187', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (302, '711a0fd960e54292a5037ada08642d05', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 1, 'OK', '2026-06-28 15:36:12.826099', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (303, 'c02d8771b5224daa9da14de3af2d1161', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-28 15:36:13.862125', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (304, '2b2c8931a47f4d7eb7ffe4734218147e', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 1, 'OK', '2026-06-28 15:36:16.716809', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (305, '9e4200df8637436a85ad5d5302341b8e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-28 15:36:19.560837', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (306, 'de49052a05d145ffbe392f9902df51d8', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-28 15:36:19.592847', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (307, 'fa38de93132543fb8cefa004a4305cb5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 15:36:20.162551', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (308, 'a725fb1005a54e4fa484d4308d501c69', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-28 15:36:20.210492', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (309, 'e315759cd06d4f839ddb81a69dcae5f4', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-28 15:36:20.842999', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (310, '5f62f048a71c49cba59c66ca4d5613c7', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 9, 'OK', '2026-06-28 15:37:23.715287', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (311, '131be1977645458cbe0e7254fde9f576', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-28 15:37:26.174778', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (312, '1aaf4c50edf4434eb95dbc7e7405050b', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-28 15:37:26.200810', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (313, 'b0fcb1e207cb4a41ada6687558d4f0cb', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-28 15:37:30.140905', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (314, '5487375bf9e74d0ba6f8f0dc570acc7c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 9, 'OK', '2026-06-28 15:37:36.123253', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (315, 'dd25952991d947d6a561afe1fcad8250', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-28 15:37:42.289184', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (316, 'cd9c361e519d458daf4e93a7d08931f5', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-28 15:41:11.945406', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (317, '984e6a11e8194da3916b1f6e365cb590', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 6, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-28 15:43:20.621143', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (318, '632f34b98a6944e99648c6fad7834c50', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-28 15:43:20.920180', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (319, '465d509612794bcd8c190ff080aaaadf', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-28 15:46:56.824480', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (320, 'd04a76502ddc48b58680ba99eed2d5e5', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 5, 'OK', '2026-06-28 15:48:51.744793', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (321, '3aa3e4239e3f4d0a9b7c5d55970453a8', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-28 15:49:12.473040', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (322, 'e1f08d697d8544d7acb9ca761bcbdf1e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 12, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-28 15:52:46.836238', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (323, '1963a4d297ae49419e6af85173835da9', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 5, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.ON', '2026-06-28 16:08:26.765831', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (324, '7c3677e19f85470eb8fe654088617c1b', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 5, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.ON', '2026-06-28 16:08:36.744189', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (325, '9ff9d150c2d3452aa504efeb9d3c7fc2', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 4, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.ON', '2026-06-28 16:08:56.476166', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (326, '49140b16d78d4b23939e48f1ecd40ad0', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 16:09:16.510115', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (327, 'b7772ea5dc6a473a828608d4540fbfdf', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', false, 9, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.ON', '2026-06-28 16:09:16.699426', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (328, '661dda0a255c428f92dea0f0495cf0ba', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-28 16:09:18.011313', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (329, '3a5db747f0a04789aab5e06df55a3e2f', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-28 16:09:18.258022', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (330, '86c1aeb8bc994efa8520328fcaac748e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/terms', 'GET', true, 0, 'OK', '2026-06-29 01:30:02.525685', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (331, '158982777aa24f09a57cd0701398fcca', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-29 01:30:02.526059', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (332, '7fd95c72e11c4102b6a79be9c2bd4f30', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 90, '用户名或密码错误', '2026-06-29 01:30:02.703175', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (333, 'cee588773a2a474abe74c6f46e58f6ee', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 128, '用户名或密码错误', '2026-06-29 01:30:34.828800', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (334, '4c89f697765b4dc2ae1abaaf36e8b5b4', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 135, 'OK', '2026-06-29 01:30:34.836312', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (335, '8258f97e57374b12a5f3242217a96331', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-29 01:30:36.750424', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (336, '2e4b723164d741ffb106c01fc0455977', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-29 01:31:49.720477', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (337, 'd05c634c23b44befaacf22cc4c18eaed', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/terms', 'GET', true, 1, 'OK', '2026-06-29 01:31:54.493617', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (338, '85a46a0fcbcf491582dc1854f44587d8', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 119, 'OK', '2026-06-29 01:32:07.918220', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (339, 'd714db0b8c624657b232caaeed603220', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 20, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-29 01:32:08.055406', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (340, 'e63a59a255f94453ab16d2cf80e19ef2', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-29 01:32:13.892170', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (341, '46032e6f1b244fd5b96ad9f42e554cb7', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 5, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-29 01:32:15.310160', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (342, '2e119e8dac484b9bab20753a3f8dfa09', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 01:32:17.356080', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (343, '491217bf065c467faf2444f4b892e6de', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 7, 'OK', '2026-06-29 01:32:17.626581', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (344, '3ecd813db0af4e32b6e552b6a9a86c4b', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 5, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-29 01:32:21.929360', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (345, 'c87db47e1a2949c6806631df84b490fa', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 01:32:23.752874', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (346, '09d3fc3ad8f84861993628fe7b72f381', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 01:32:24.013890', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (347, '1d21a650dd974094a45929d65ede51b8', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 01:32:51.471703', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (348, 'ff3293b769944e2293ff7573dab22527', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 24, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-29 01:32:53.703290', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (349, '37198b7ec6a5457096061075559340a3', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 6, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-29 01:34:13.521739', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (350, '59d8b9a55a6e41f4aec598c0ae6422d1', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', false, 12, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-29 01:39:00.371163', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (351, 'c60a2355da2745838f9e580b521b83a5', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 21, 'OK', '2026-06-29 01:39:46.587719', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (352, '943fb44c4f2a4e01918bda412ab02f74', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', false, 4, 'No enum constant com.morel.greenhouse.domain.device.DeviceStatus.OFF', '2026-06-29 01:40:09.004060', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (353, '0bde0a9269ea4e04ab14eeb8f2577ba9', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 5, 'OK', '2026-06-29 01:43:46.496038', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (354, '16dd8a4b9e154b92a556edcb1224b6f5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 8, 'OK', '2026-06-29 01:47:20.523273', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (355, 'e30987efe46644da8fb543d0f5fc814a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 01:47:22.563278', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (356, 'bb88d47b66bd49ba851924a7481798d7', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 20, 'OK', '2026-06-29 01:50:43.402529', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (357, '96bd4fce136d46d883146ea885bf0c6a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 01:50:45.381716', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (358, 'e0d572f8d2ec463b9b86d7e3abef91eb', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 12, 'OK', '2026-06-29 01:54:21.353754', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (359, '3d3f6342fd73483dac90bcdaf4874993', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-29 01:54:23.362317', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (360, 'fe44101eee064b39a74245bdec44decb', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 27, 'OK', '2026-06-29 01:54:43.947918', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (361, '602272d83e3d4a14975f6e87b020e8e0', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 284, 'OK', '2026-06-29 01:55:45.855714', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (362, '9e0097a9ccdf4c16b9828d4fc43bcb69', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 84, 'OK', '2026-06-29 01:55:46.009510', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (363, '5f6f026e2aaa4fd6afe0a2d360b8460e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 01:56:00.026842', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (364, '7925b57a099943c19b144d2cecdd4468', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 12, 'OK', '2026-06-29 01:56:00.314442', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (365, '731f69bd297c47758f1630183c38bff5', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 01:56:08.366095', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (366, '8289880ae0244a7d9291e6d72618329e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 01:56:08.700093', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (367, 'c771f4c15b01484cb7d61eee882985ee', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-29 01:56:16.591688', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (368, 'd0e8d4f1c0d84b4ca7c0803d27ae8b83', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 01:56:19.521573', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (369, '3837dbf72e2f498cb2129dd94af20a9d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 01:56:19.787244', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (370, 'cb51bf5fb0d241b58e191844e9810899', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 01:56:20.893859', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (371, 'b837a2ef512e484eb06f9e9984207e15', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 3, 'OK', '2026-06-29 01:56:22.904861', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (372, 'e4cbf674bff74d18a55a915b416852d5', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 01:56:26.935699', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (373, '2f38c911bb9d479fa12a55e7008e35d6', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 83, 'OK', '2026-06-29 01:56:29.226684', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (374, '86c73a89b45b41d6875a7800dd525052', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 01:56:29.690926', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (375, 'f347402832e44409975e2bab52938bae', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 01:56:53.251691', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (376, '40d6a05eea804ed68d3ac854167c0a63', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 8, 'OK', '2026-06-29 01:56:54.926936', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (377, '47693b1bff8045a8851073589faf958e', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 4, 'OK', '2026-06-29 01:59:51.798073', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (378, 'f7ceb8fcb49e4bec84b5e0acdca540cf', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 2, 'OK', '2026-06-29 01:59:53.587531', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (379, '36bf102b123845b390336ac3dbc4c849', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 01:59:54.768939', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (380, 'adeabb6ddce54d95abede1fe401be67f', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 1, 'OK', '2026-06-29 01:59:57.136909', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (381, '9f306efc426b4edaa09623846805b35c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 6, 'OK', '2026-06-29 02:00:30.015517', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (382, '5d40af4e54ff470486e7a1e6dfc04ba8', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-29 02:04:47.858691', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (383, 'a731b531860a4a3ba087dc5498b44f1c', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 02:04:59.917672', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (384, '48582b607baf40f6b696b1caaa8b598a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-29 02:05:33.318428', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (385, '20c04dccd820462083dff0856910019e', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 59, 'OK', '2026-06-29 02:05:33.637711', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (386, '0db2262df8354bd09f1f5d04e9fc97da', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 11, 'OK', '2026-06-29 02:24:35.296576', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (387, 'e0c8fd13de734c5e95f5fd230edff1b3', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 11, 'OK', '2026-06-29 02:24:35.297091', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (388, 'd42ebeed77414489ac14d4a2c10bfd7a', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 02:24:37.300732', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (389, '19bd2aa07129441c8c791ba8208c5f3a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 02:25:43.412955', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (390, 'c4993c8d975e4617a3b248223d140b70', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 108, 'OK', '2026-06-29 02:25:43.553699', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (391, 'eb0d027186c04fe9aad3f42ceea9405b', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 19, 'OK', '2026-06-29 02:25:45.461599', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (392, 'f774e5b976044bb9a41b79eee422036b', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 6, 'OK', '2026-06-29 02:27:31.924496', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (393, '1907d6397ff1460cbfb9661f4c7f86ce', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 5, 'OK', '2026-06-29 02:32:16.963227', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (394, '9ab6727f6dc24453bc3c9a8ccc8e7923', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 11, 'OK', '2026-06-29 02:36:10.302532', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (395, '154fccd074214e45970d8376284e7be9', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 02:36:59.945280', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (396, '6920b0a9dcd0459cb9ffb8a6f60b15c7', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 02:37:04.743229', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (397, 'a6f712c33b5c4b839fdfcdfdf648770a', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 02:37:06.327560', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (398, '29cd4738e2de407183a96dfd375a1833', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 32, 'OK', '2026-06-29 02:45:50.752852', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (399, '3e69c5b5d9a94ac3983f1699ac19f7e1', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 18, 'OK', '2026-06-29 02:45:52.734413', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (400, '1e5a8579282046e5bc3a6547d64967e9', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 19, 'OK', '2026-06-29 02:45:56.991044', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (401, '4003eb21714b45e2b31595b42ae959ce', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-29 02:45:57.009026', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (402, '9c721d04c46549619be5cfb3128e7bb9', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 02:45:58.965870', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (403, '03bd4ca36f8e40f0a33f1dd3d679e356', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 20, 'OK', '2026-06-29 02:45:59.311121', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (404, 'b134fcc764064ee595bc962f10f4ec01', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 02:46:02.180417', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (405, 'a76b6b9b71f84912846aa54fe1953001', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 3, 'OK', '2026-06-29 02:46:04.030221', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (406, '55ee279b220246e0ac192ed53e5f7c49', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 02:46:05.945923', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (407, 'fa4f46b673894324bdd3cebf40dcf6d5', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 02:46:07.976404', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (408, '21dfea928b6a4cce8be697e0ecb0f60f', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 4, 'OK', '2026-06-29 02:46:08.827552', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (409, 'b088cf11c967440d859a3632319aef5a', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 14, 'OK', '2026-06-29 02:59:18.318697', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (410, '2861e80efcbc4c5e9022a42a9afda605', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'handleAlert', '/api/v1/greenhouses/alerts/1/handle', 'POST', true, 10, 'OK', '2026-06-29 03:01:31.559147', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (411, '326f28a4db0c4d1da65c003d44b65a54', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-29 03:01:48.541513', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (412, '84a0da0d89b4448a9f4994622e9a3b23', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 68, 'OK', '2026-06-29 03:02:11.771745', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (413, '147b0b2cac6847e9a350df1b26860dca', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 22, 'OK', '2026-06-29 03:02:14.531888', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (414, 'afc32a435ad641f1860fc2d6b6bab8d7', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 03:02:17.436372', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (415, 'b7750fcdaf3e4dcfbb43332505b2a95c', NULL, '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 5, 'OK', '2026-06-29 03:02:18.597257', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (416, '1543e10bc7eb413f995f17fadd150f93', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 53, 'OK', '2026-06-29 03:02:22.057990', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (417, 'afd2a24e04cd4d52a0e1dea22f65de78', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-29 03:02:22.104834', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (418, 'd3cdb01960b04c76b57ea75cbfca942d', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 03:07:57.701136', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (419, 'be21b98c091348f2ba22a59f58b2e4d9', NULL, '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-29 03:07:58.951843', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (420, 'aeb22229181c4a7e87b7785b231fe545', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 105, 'OK', '2026-06-29 03:12:02.953098', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (421, 'eb3d0fcf565c4891b523ad3402eb2eff', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 70, 'OK', '2026-06-29 03:12:39.857898', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (422, 'a47bdd59d6574f0dbb05f19e318e91fb', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 78, 'OK', '2026-06-29 03:12:39.865649', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (423, '441d152fdb654b51919c77b3314ea9cc', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 03:12:39.906382', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (424, '3e9f0ba753a9405e9807bb4a18575a81', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 2, 'OK', '2026-06-29 03:12:41.948348', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (425, 'ed777305b84c413187548a99e7775c06', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 70, '用户名或密码错误', '2026-06-29 03:14:41.100655', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (426, '114b111b0dcc406fa211c569a1b0b7d5', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 70, '用户名或密码错误', '2026-06-29 03:14:41.102323', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (427, 'f9c6bce970764f6abb61eaba8c39fc1e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 106, 'OK', '2026-06-29 03:18:24.633690', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (428, '298211f11a374abbb1c47c6bf251b2cd', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 104, 'OK', '2026-06-29 03:18:24.634024', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (429, 'd9b71c6887ac48ed904c534b514969f7', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 106, 'OK', '2026-06-29 03:18:24.635458', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (430, 'd6607f455bb94620ae0dcc291385f3b2', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 1, 'OK', '2026-06-29 03:18:24.673080', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (431, '5264a1ed3d7a474dbe5044b140dca84b', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 03:18:24.675285', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (432, 'ab82203fa73847a390b7d3bebe4d52e5', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 88, 'OK', '2026-06-29 03:20:57.519253', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (433, '3b9590b835594b07a7079f2272122a52', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 88, 'OK', '2026-06-29 03:20:57.519635', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (434, 'b35337095d814e529cd63e465ea576c2', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 2, 'OK', '2026-06-29 03:20:57.562286', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (435, 'c98843193edc426f9966c1b338b9933b', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 167, 'OK', '2026-06-29 03:21:57.830133', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (436, '64cb5beb21e04c33ace14754a5e5c369', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 20, 'OK', '2026-06-29 03:21:58.207850', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (437, 'f74d4e9294d2404e8c55032144729a9a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 03:22:03.177979', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (438, '8e8cf752f9a74cd5bae59e4da79c4cde', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 03:22:03.583059', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (439, '6f56a69af1ef4600a26c7c6601e4fd90', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 03:22:05.701443', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (440, 'd4d026565c8846759807a6639ba417ee', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 7, 'OK', '2026-06-29 03:22:06.060502', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (441, 'aaacce61ca5b4293a632219a52eadc87', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 03:22:12.599888', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (442, '0cc20313c8714a15934e7480d12c0f11', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 3, 'OK', '2026-06-29 03:22:15.039647', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (444, '6ce2e5449aa54bfeb80a03121be15f5f', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 03:22:18.944085', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (445, '29dd7bd3bd1f4140be3e0ce706552a08', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 4, 'OK', '2026-06-29 03:22:19.963047', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (446, 'bdff216686c74ca3bd6f8a0fbaf47fe1', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 2, 'OK', '2026-06-29 03:22:41.927531', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (447, '69a51536a6fd4b0e83c2657c6682d757', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 9, 'OK', '2026-06-29 03:22:46.952271', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (448, 'cb7aafe5dba34fbfbcbd283343d1fd2d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-29 03:22:56.035977', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (449, 'd7df8c6e00194795b16e70880cc7318f', NULL, '0:0:0:0:0:0:0:1', 'HealthController', 'health', '/api/v1/health', 'GET', true, 0, 'OK', '2026-06-29 12:36:54.011385', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (450, '039900f19ad54fdfa5c0dff337f53a09', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 125, 'OK', '2026-06-29 12:36:54.241176', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (451, '2ca1677386ca4368ae1812d378c03e37', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 20, 'OK', '2026-06-29 12:38:40.579529', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (452, 'db7ad83ba1be420994e0abe12c7dc2f5', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 170, 'OK', '2026-06-29 12:39:52.528242', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (453, 'e8ee36441cdf45029095557062341821', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 96, 'OK', '2026-06-29 12:39:52.724031', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (454, '445167d07a5f4f0db73e003428dc77ce', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 7, 'OK', '2026-06-29 12:40:04.187563', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (455, '5f357097610f4562b88341b74fdc33eb', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 12:40:04.383629', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (456, 'c067303683f14e4c8e84800bcbf6c47d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 12:40:07.623978', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (457, '07f408a72b064dfa8fe5bd379986712f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 5, 'OK', '2026-06-29 12:40:07.971705', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (458, '9e54156ad2ae4a68a48433b31ef8ae0f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 12, 'OK', '2026-06-29 12:40:13.524073', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (459, 'ce4b4e08d3dd4a94b59420e017f137c9', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-29 12:40:16.780740', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (460, 'bf7de10738b0413bb07a364419ae0dc3', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-29 12:40:18.902710', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (461, '1c7575f1e72542afb8a11354adb9d853', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 41, 'OK', '2026-06-29 12:40:21.513207', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (462, '947a74c2717d4ad09ba1ee7645539d01', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 12:40:22.581635', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (463, '451fac92acec4a789fdfbe8eb61e32c0', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 85, 'OK', '2026-06-29 12:40:49.812662', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (464, '8535dca54838467db3579d5f1c82e598', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 43, 'OK', '2026-06-29 12:40:53.272878', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (465, '3dcf843fda2a463a85aeea7b07b70b06', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 12:41:29.376198', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (466, 'bce7976ec30d4851804a1e8d0323c28d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 12:42:21.947101', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (467, '1743da223b1c416081127aba1492d763', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 12:42:22.281863', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (468, '48c3d3de76ce4563b3105d6820ee50d6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 12:42:25.474811', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (469, 'c852e92a251f40179c6a83e90162bbfb', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-29 12:42:25.810306', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (470, 'bf7e14595fc8473dbd566e495e6fc12b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 0, 'OK', '2026-06-29 12:42:55.512451', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (471, '9f361b2694d84548a6f69941bce470fd', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 38, 'OK', '2026-06-29 12:42:57.759570', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (472, '5f987b6874114d70a3d691c7eca0f1d6', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 11, 'OK', '2026-06-29 12:43:00.614807', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (473, '820bb1f459684e6fb397bd3e2ecbbc59', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 3, 'OK', '2026-06-29 12:43:03.069658', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (474, 'b8198c03f6d6426fb58b7cf6acfcc1d2', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 7, 'OK', '2026-06-29 12:43:03.741294', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (475, '3696db75eed541eb9500c36b14c9e772', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 8, 'OK', '2026-06-29 12:56:04.477574', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (476, '370fccb935d04f62a0c514033a51a44e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 12:56:06.205536', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (477, '8166a740ab7c4c30aaadfb04110add62', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 12:57:55.935687', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (478, '45a17509d18c48818b26d7606c7ca162', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 12:57:57.397655', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (479, 'ea97916b9226448ab3975aa4240ab63c', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 12:57:57.745108', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (480, '7bd25786ea184f0e81fa688ccffd20b8', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 25, 'OK', '2026-06-29 12:59:39.909683', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (481, '1da3fcb538234a44b5fa913e4944962e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 158, 'OK', '2026-06-29 13:04:36.650010', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (482, 'ecc0e892a26d42de863c8df1dd9da58b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 32, 'OK', '2026-06-29 13:04:36.843004', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (483, '06ec45481b98422a86389ba3d5dac5c9', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 137, 'OK', '2026-06-29 13:07:43.690055', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (484, 'dac69f2c60bf4b068702a82f8ffa1625', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 20, 'OK', '2026-06-29 13:07:43.896616', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (485, '8776ba6cea494071acc7d54e3b96b508', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 194, 'OK', '2026-06-29 13:14:05.976684', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (486, 'bfac3dd7f0ce4e08b72fa6c907f6531b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 46, 'OK', '2026-06-29 13:14:06.102914', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (487, '149c1afb7d4f425d8ecf48d1b905df58', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 37, 'OK', '2026-06-29 13:14:06.568293', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (488, '5f40cf69a35244169cafe1149840c958', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 153, 'OK', '2026-06-29 13:45:24.656472', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (489, 'c543e95799b544d88696089956f1aef1', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 16, 'OK', '2026-06-29 13:45:24.814927', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (490, '0dc2ede6cce9498d876f173f8480ab5a', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 14, 'OK', '2026-06-29 15:18:20.466916', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (491, '2d605829b4554bfd8f254582621fd592', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', false, 20, '验证码发送过于频繁，请稍后再试', '2026-06-29 15:18:20.555184', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (492, '3d8b959b46fe4748b51f39681c30a0a0', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 24, 'OK', '2026-06-29 16:21:01.120264', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (493, '41ad538b37c34d8991878a5dfba1db55', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', false, 7, '验证码发送过于频繁，请稍后再试', '2026-06-29 16:21:01.235417', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (494, '2f59d34a76b945adbd22ac1175523782', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 12, 'OK', '2026-06-29 16:33:52.750017', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (495, '37dda4e28c144cc6a39cfe05fb432a68', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', false, 16, '验证码发送过于频繁，请稍后再试', '2026-06-29 16:33:53.143763', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (496, '796d77ad276f4d49b4dfd8461790cda3', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-29 16:35:22.615259', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (497, 'e2f091862a4341148af3986948b000b5', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/privacy', 'GET', true, 0, 'OK', '2026-06-29 16:35:24.227990', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (498, '31e3497beb47420397ce5cc2d78d38e2', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'policy', '/api/v1/auth/policies/terms', 'GET', true, 0, 'OK', '2026-06-29 16:35:28.522457', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (499, 'c5dde1fe8378403e8a8a97f11d308f51', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 298, 'OK', '2026-06-29 16:35:33.785736', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (500, 'bfbb1d6485ea4075932bbe3514a589fb', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 76, 'OK', '2026-06-29 16:35:48.451711', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (501, '602cfd7b255546f6a5329716ae02dd9e', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 44, 'OK', '2026-06-29 16:35:51.268781', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (502, 'e069c773ffc44dd9b4ae59e6460bd994', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 16:35:53.954130', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (503, '57e3c89c44dc4c7587330a34d7669b49', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 16:35:54.202112', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (504, '334b213afd27452ba6e56d35dd156059', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 53, 'OK', '2026-06-29 16:36:05.267794', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (505, '2296f11d57934094a3f4085adcaa2319', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 57, 'OK', '2026-06-29 16:36:17.169844', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (506, '767f56a5e2f74f97b08049b1dcf4b946', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 41, 'OK', '2026-06-29 16:36:34.748033', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (507, '2e5cf5d22eb1419683b51f6ae6a79935', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 16:36:43.456066', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (508, '5ea255d9e9524795b584f9d772e54237', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 283, 'OK', '2026-06-29 16:36:43.998104', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (509, '4a30e37a2a7b408c83eef54c57ca7d0a', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 45, 'OK', '2026-06-29 16:36:46.632784', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (510, '7061aa693aa44968b4d7d04278951f87', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 34, 'OK', '2026-06-29 16:36:58.982790', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (511, 'eac0295dc2c74cf7a53e4e5516106964', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 29, 'OK', '2026-06-29 16:37:02.329624', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (512, '2b22179fddeb415ea40868a240f166f4', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 19, 'OK', '2026-06-29 16:37:03.767808', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (513, '6142e62ae8ce45da9ef2abb23dd27d39', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 12, 'OK', '2026-06-29 16:37:03.941555', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (514, '1ff080c4fff44035afc4471dea8af35f', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 10, 'OK', '2026-06-29 16:37:04.140141', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (515, 'c49f7c1504f44b70aa5dd18f69ed0fe3', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 33, 'OK', '2026-06-29 16:37:04.418104', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (516, '52b5ebed87d947e3ab35c60e907f322f', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 16:37:04.790876', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (517, '57b5f912c3b14a34bce5dd0e95b625c6', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 13, 'OK', '2026-06-29 16:37:05.158465', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (518, '9e7987ef632d444dae782367301ff4d2', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 16, 'OK', '2026-06-29 16:37:05.420022', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (519, '457892d65b574670873524d9f563030e', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 12, 'OK', '2026-06-29 16:38:17.256334', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (520, '5b77e5ab804c454d9ab6246e8548c73e', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 15, 'OK', '2026-06-29 16:38:17.507553', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (521, '6ed5e878f75a4e66ba95ca0b8b1a8c21', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 31, 'OK', '2026-06-29 16:38:17.800120', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (522, 'cf267cabf4e4482ab40291d380878d00', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 16:38:19.612555', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (523, 'd4af8de7031a4800963d8d09e5e3c54c', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 8, 'OK', '2026-06-29 16:38:19.971817', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (524, '49f31732f7ff4a16ae4e6988361ac943', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 6, 'OK', '2026-06-29 16:38:47.920322', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (525, '266712ba081d4b0fb94e311c51321d30', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 38, 'OK', '2026-06-29 16:39:02.046399', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (526, '4551c30a74514e2999b7c3e0a1c9e6b9', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 20, 'OK', '2026-06-29 16:39:03.038297', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (527, '33acf77cd96e4e83b640627385ec8c57', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 12, 'OK', '2026-06-29 16:39:03.205224', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (528, '8e1be1cddf8a49089be23bdb409a8b87', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 14, 'OK', '2026-06-29 16:39:03.487701', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (529, 'bbf6ea54051649d1a5d6d0a872e73321', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 63, 'OK', '2026-06-29 16:39:04.040841', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (531, 'f99a351678a645d397d96084aa81ff83', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 300, 'OK', '2026-06-29 16:39:08.046665', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (530, 'f55ebe416a914bf2af1a0aa7405397f4', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 16:39:06.841689', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (532, 'ec7fe1477cb34246ae19256e0ceaf4f4', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 0, 'OK', '2026-06-29 16:39:08.065072', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (538, 'bc86872c154d4bf1893e546a14086e40', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 45, 'OK', '2026-06-29 16:39:34.062296', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (540, 'b73c9f5af7c04c5ab5e079860fa448ab', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 7, 'OK', '2026-06-29 16:39:37.556012', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (542, 'fb7a25e9e5904047bb1b61ac62e88a00', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 496, 'OK', '2026-06-29 16:39:42.711704', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (550, '3e20d254473e4e54baf1006c67362b45', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 54, 'OK', '2026-06-29 16:41:52.727682', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (552, 'b30e7b201b8f42c9a001ee09bab0ab53', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 6, 'OK', '2026-06-29 16:43:51.555813', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (533, '07f20081e3ca470ab8c4c57a559b4983', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 3, 'OK', '2026-06-29 16:39:25.531562', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (534, '2571393b2f1c484eab628579e0746e18', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 12, 'OK', '2026-06-29 16:39:27.767087', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (535, 'f25bc5b3e07949d0b406f48332cb0a02', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 7, 'OK', '2026-06-29 16:39:30.296610', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (536, '930936beefac42419871f0bb1c26e904', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 12, 'OK', '2026-06-29 16:39:30.879485', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (537, '9305a991f6fb4000b81c98cbc1f92543', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 40, 'OK', '2026-06-29 16:39:31.254246', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (539, '97d8178177cb4a49b064280def4aaaf1', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 16:39:37.300202', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (541, '61f99bc79b34415aa5493bac3068d82c', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 21, 'OK', '2026-06-29 16:39:38.926474', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (543, '96ddd1372a034cc7a884dbb5af5be86f', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 95, 'OK', '2026-06-29 16:39:49.756958', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (544, '3d9d6c7d130a4a00824a42c4bec0ff48', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 12, 'OK', '2026-06-29 16:39:56.679888', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (545, '6037aaaa480141d68ec41a5aa734a46d', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 8, 'OK', '2026-06-29 16:39:56.874963', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (546, '593c603e05814beabdf81d405f9771f6', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 24, 'OK', '2026-06-29 16:39:57.045843', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (547, '8efa23b923f34c47aac0007a7f2f9321', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 158, 'OK', '2026-06-29 16:39:57.296834', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (551, '907752d2236043499765279bf1968ca9', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 17, 'OK', '2026-06-29 16:42:35.337795', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (548, '523687ec7b8044e69507b8bfed157c0a', NULL, '0:0:0:0:0:0:0:1', 'HealthController', 'health', '/api/v1/health', 'GET', true, 2, 'OK', '2026-06-29 16:40:01.747936', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (549, 'f745ef4f749443d2ae245a9928737b01', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 79, 'OK', '2026-06-29 16:40:01.829675', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (553, 'd7eb5b4637664817a5ff3c208cc92e69', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 11, 'OK', '2026-06-29 16:46:27.214485', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (554, '30c538658dac4c22a4629fde3c145ac2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 14, 'OK', '2026-06-29 16:46:28.171699', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (555, '5e5a6d3a7e014de28aa77b8f941ce643', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 179, 'OK', '2026-06-29 16:46:47.665368', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (556, '7170d701c7ab49c48dac913918cf69db', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-29 16:46:48.062143', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (557, 'cf91d0cfca8d48b5a0c5356436addb2a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 12, 'OK', '2026-06-29 16:46:48.330922', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (558, 'd4dca871b581499cafc9922ae5a21312', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 16:46:50.514632', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (559, '01b6f8b55d8b4f548e013e8c3d3c34ee', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 16:46:50.856379', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (560, '3d08e87d1429461cb20844729b258cb9', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 16:46:52.940832', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (561, '06cdf0973c2e43eb95e2fdcb2cf2976a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 6, 'OK', '2026-06-29 16:46:53.288627', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (562, '87c69baf20d543b4b23b71ab9f7a7d57', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 4, 'OK', '2026-06-29 16:48:15.951126', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (563, '0708044d626e4527ba2c38dfd60e5d84', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 5, 'OK', '2026-06-29 16:48:18.203551', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (564, '9ff8ab1d0c324a7fb6097bd1445a22fc', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 18, 'OK', '2026-06-29 16:48:40.929599', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (565, '4e516de69526445d9df041f058d66857', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 100, 'OK', '2026-06-29 16:48:41.916067', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (566, 'c6c75e71749346da9b5479cfd769e2b1', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 193, '用户名或密码错误', '2026-06-29 16:49:05.809293', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (567, '96933b0e20fe4a77aad7fe2dd012667d', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 249, 'OK', '2026-06-29 16:49:27.857251', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (568, 'e90445cab1c445f4bbb493c7913c4a37', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 17, 'OK', '2026-06-29 16:49:39.135421', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (569, '31e3b2be92d94ce683bf5566b3535cc3', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 8, 'OK', '2026-06-29 16:49:39.359036', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (570, 'a4eae52c02004b0896c346d1b4d5276c', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 16:50:18.656296', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (571, '44dd3f00dbb348ae8b672a93be06549a', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 16:50:18.986687', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (572, 'f4b2b6a36b594db48c8a1989ea219d06', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 16:50:46.667236', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (573, '333db93852474510915fb921ecda265d', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 5, 'OK', '2026-06-29 16:50:47.044556', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (574, '26ed7d3b9abc40499e53028e4b16228b', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 16:50:48.568325', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (575, 'd58b0746a5f64e20ba80694692653595', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 16:50:53.430668', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (576, '3ce6a19f840f485bac3a9d1636387643', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 16:50:53.683155', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (577, 'f96b07f193484902afa52faeae82b63d', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 16:51:05.872925', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (578, 'd936abaccf0c43a09df316f84ab8315c', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 16:51:09.271973', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (579, '9e7781b374314d0f8db394a831e45c21', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 16:51:55.638110', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (580, '35c5690673d24d9f8cb32fe9a0cffdc6', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 10, 'OK', '2026-06-29 16:51:56.037736', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (581, 'bb70ea21956e4532aa4b4bde06929673', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 16:54:36.881948', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (582, '74ccf1d759dc4a72853d3cd668f836e1', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 16:54:55.187136', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (583, 'a370e51e81a1418c8e6f7c9168d687fa', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 95, 'OK', '2026-06-29 16:54:57.995470', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (584, 'fea705d72e104fbc81490ea01adc4fbd', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 10, 'OK', '2026-06-29 16:54:58.129577', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (585, 'dde8f165f9fa41a68913e729b0e4b73f', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 16:56:03.059100', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (586, 'e5fde0f990354bfaa5ac4797623c53d0', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 16:56:03.325268', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (587, 'fedd8d50fc1e4caa85b398ce6cdb0c07', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 16:58:42.980143', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (588, 'ee16fb87d4f8425bbbd3c58a1fce47e6', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 34, 'OK', '2026-06-29 16:58:43.238157', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (589, '893555a49da048689ddb5241c5e5fd73', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 16:58:46.181047', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (590, '8925a483f85c4142ac2a2b4b887ae9bb', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 9, 'OK', '2026-06-29 16:59:03.203698', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (591, '532ecba8f971408bbc06245ae40418a5', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 12, 'OK', '2026-06-29 16:59:03.617692', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (592, 'ab1736f73cda433d8c0faef91524b1f3', 'CM+', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 2, 'OK', '2026-06-29 16:59:31.203272', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (593, 'dc8dfb2d59624b0692bfa836172b0391', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 17, 'OK', '2026-06-29 16:59:42.054354', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (594, '08c0d791dd0c411e843725679bb54a21', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 136, 'OK', '2026-06-29 16:59:42.257040', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (595, '61430ec9478344caa216c6393583a212', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 13, 'OK', '2026-06-29 16:59:42.295320', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (596, '64e8eec1fbdf430fa93f4e3a965a87f7', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 7, 'OK', '2026-06-29 16:59:43.989215', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (597, 'a13fcc6c058741c49ea451fbb8f11ecf', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 80, 'OK', '2026-06-29 16:59:46.412212', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (598, '6fe426a31e6f42bea2078a19e7d17956', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 66, 'OK', '2026-06-29 16:59:46.980566', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (599, 'c41ca15e1145477a8c2485f4aeefab93', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 29, 'OK', '2026-06-29 16:59:47.491541', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (600, 'b5a6c8fc72bf432680fdda8de3022764', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 78, 'OK', '2026-06-29 16:59:47.546674', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (601, '91d9bcf4f0584e6dbc229d5444a94f65', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 20, 'OK', '2026-06-29 16:59:47.922304', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (602, '45e2b4889b72418dadd78456d6bf0456', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 87, 'OK', '2026-06-29 16:59:48.229801', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (603, 'c4a0e997f64443db918cda151432f1e3', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 10, 'OK', '2026-06-29 16:59:48.343820', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (604, '39a86f80712f487ba84f331cb99baa1a', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 32, 'OK', '2026-06-29 16:59:48.376715', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (605, 'fa2bf242dc0647df929b7576a53e6c8a', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 15, 'OK', '2026-06-29 16:59:48.696652', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (606, '3d1845e117b7448e84c4a0f34b279aba', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 225, 'OK', '2026-06-29 17:00:01.304843', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (607, '4abac6ddab744668851c571921d17d35', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 10, 'OK', '2026-06-29 17:00:02.978784', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (608, '6a269412bfb6403f8af4fa7ef11bb422', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 8, 'OK', '2026-06-29 17:00:16.163755', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (609, '648f7cc0fc26451193f5a209d69cc61e', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 6, 'OK', '2026-06-29 17:00:18.379716', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (610, 'e5355bbd8fa447609d5dd54fb73d014e', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 9, 'OK', '2026-06-29 17:00:19.509445', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (611, '2b4697546a8142a4a31c5af8f97ecda3', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 7, 'OK', '2026-06-29 17:00:21.399121', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (612, 'c3f3283febf840139fd4bd0eba3a30b2', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 17:00:21.777577', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (613, '7d75d1ab7cad48de8fe9f7e63f6ef00a', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 5, 'OK', '2026-06-29 17:01:22.610246', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (614, '5d24de46953241afa280fae5c06a7822', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 42, 'OK', '2026-06-29 17:02:32.745080', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (615, 'f96ecb4749e1446aa43664b5cebdbb56', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 8, 'OK', '2026-06-29 17:02:33.199229', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (616, '26af60c1852a4970a509a73b6bc8a756', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 11, 'OK', '2026-06-29 17:02:34.991479', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (617, '19c2a341e7374ad2b485df10c523249f', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 2, 'OK', '2026-06-29 17:02:36.266450', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (618, '097455f3ac5c4d5e82c34f2c40b98fca', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 7, 'OK', '2026-06-29 17:02:42.678927', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (619, '67d1173fc808457395ee3a0c04e5a74c', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 92, 'OK', '2026-06-29 17:05:39.186173', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (620, 'e12ac6732b09418bbe381efbabb4239b', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 77, 'OK', '2026-06-29 17:36:27.325933', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (621, 'e6f598e74fe34178a337a3cdf68b5ef9', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 17:47:41.135712', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (622, '8a033423600e4aacbbc9957d5efdea02', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-29 17:47:42.018301', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (623, '36a6f89d0f4a4c85965661c6e5983b75', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 17:49:21.164581', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (624, 'e1ad380bd2694d428794897b7de34e92', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 17:49:21.200993', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (625, '55b7026f35574104baed6a34d3df8751', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 8, 'OK', '2026-06-29 18:35:47.363076', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (626, 'a08f432573f24edcb542267e93b88088', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 10, 'OK', '2026-06-29 18:36:03.570798', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (627, '73197ae34cc64a4abb632ea7e2a47c7b', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 17, 'OK', '2026-06-29 18:36:03.624206', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (628, '3b3ab5362ea640e4b597b22c3ccac87b', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 13, 'OK', '2026-06-29 18:36:04.664501', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (629, 'e4beff5166ae43bdaec857243daf2e58', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 92, 'OK', '2026-06-29 18:36:04.814476', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (630, 'eb3cafde67534c5ba874acedc753324c', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 18:36:06.267537', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (631, '31114a09db5940be9df0483c4607c6d3', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 92, 'OK', '2026-06-29 18:36:06.741415', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (632, '72e97ad8abf243539f195f21ff177460', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 146, 'OK', '2026-06-29 18:36:06.909783', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (633, 'f84c03d307dc43e9a5ee0d2347b040dd', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 18:36:50.453001', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (634, '45dcd149fff04d2e8bc1813c479f7f12', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 9, 'OK', '2026-06-29 18:36:50.804725', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (635, 'bcf6d726e5f249c08c0fe596b9c316e6', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 96, 'OK', '2026-06-29 18:36:52.321153', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (636, 'd08c3394eeba446faf385f4a42042755', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 7, 'OK', '2026-06-29 18:36:53.821060', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (637, '68d2904b00a446f0aeff42ee2121cb7a', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 11, 'OK', '2026-06-29 18:36:54.063301', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (638, 'c37dba3d38194bb29c0d4b8eec9c58c2', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 59, 'OK', '2026-06-29 18:36:54.803956', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (639, '6b41c29210284724b05ad70dabcfffda', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 10, 'OK', '2026-06-29 18:37:07.359273', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (640, 'f90e658c5c62421f8f625ae03609125a', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 32, 'OK', '2026-06-29 18:37:40.712589', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (641, '7db60a64fce54f72aa3f730af2411342', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 17, 'OK', '2026-06-29 18:37:44.484119', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (643, 'abe988e78751474abd53eb732b06a6b0', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 781, '用户名或密码错误', '2026-06-29 18:38:19.340987', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (644, '9ebe8a51bd1f4a7ab67a32d8ac43e27e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 266, 'OK', '2026-06-29 18:40:13.552330', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (645, '0e62a4e915f84f09a771351ce077e2ce', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 58, 'OK', '2026-06-29 18:40:13.667959', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (646, '3fc2a2c9e3c942dcb1e5c4d135e17ab5', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 14, 'OK', '2026-06-29 18:40:16.913684', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (647, '53a169d9dbf247ffa6e6a03d69463821', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 8, 'OK', '2026-06-29 18:40:17.159650', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (648, '20eb3a0867a34fc18460feeb29acbd28', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 11, 'OK', '2026-06-29 18:40:17.263623', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (649, '288afcf8c04f49239cf1138fa9a85ab3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 116, 'OK', '2026-06-29 18:40:17.620791', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (650, 'c5e491f0e191480abf48680f741bc981', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 13, 'OK', '2026-06-29 18:40:17.843657', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (651, 'dfbf1757a5f54c62a788ad467f6554d6', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 12, 'OK', '2026-06-29 18:40:18.650271', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (653, 'b8b6b60688514c9caf09a0f431ddae0e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 53, 'OK', '2026-06-29 18:40:20.375450', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (654, 'e234fa21157844f9ada033f3206168eb', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 18:40:29.250305', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (655, 'fe5aa3fbbad44e2b9bc54fb6a1ba7baa', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 118, 'OK', '2026-06-29 18:40:30.411486', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (657, 'e714a0afb18a4a9bbdbc2d4cceea85c3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 17, 'OK', '2026-06-29 18:40:52.489849', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (658, 'df972894423f4b9da8204bab7046e577', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 43, 'OK', '2026-06-29 18:40:52.812317', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (659, '53f341fe494e4e10a59129d16c88d963', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 21, 'OK', '2026-06-29 18:40:54.553451', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (660, '9e9748e2f3d84e92bf959ec7ad8be30a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 187, 'OK', '2026-06-29 18:40:55.178217', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (661, '39a505bbeef145cb8e0cfeaad4792206', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 417, 'OK', '2026-06-29 18:40:57.055780', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (663, 'e29d79a60cb74356b42db1a55ee0905d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-29 18:41:17.620604', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (664, 'fe7d06a9b6fe492191e907f0a2f6968a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 7, 'OK', '2026-06-29 18:41:18.804808', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (665, 'f86de8c8f5a04210b400e6cf3a644a57', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 180, 'OK', '2026-06-29 18:41:19.403944', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (667, '9c1d8bd89c2d4d1491ccfa4a4b132c5c', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 8, 'OK', '2026-06-29 18:41:24.572819', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (668, '0216e7955bc048fc828521974b217e62', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 13, 'OK', '2026-06-29 18:41:31.897688', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (669, '71b46ea3e793400397b91b29f22a2af2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 78, 'OK', '2026-06-29 18:41:32.318317', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (670, '63407887ea224a179d51a0e455c251bb', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 10, 'OK', '2026-06-29 18:41:35.945213', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (671, '805c067f661449429a6e8ae5e55eac64', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 24, 'OK', '2026-06-29 18:41:37.871427', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (673, 'eaea458594c547a9b182b00b9f4b2a6c', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 20, 'OK', '2026-06-29 18:42:01.988333', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (674, 'e9a6021c27e74bc68f404912704906d6', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 37, 'OK', '2026-06-29 18:42:03.704108', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (675, 'ac2fae64b0ea4f21bdd7013707863f1c', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 13, 'OK', '2026-06-29 18:42:04.388402', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (679, 'fe99f88079d144408036ecb4e3cfdd8b', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 36, 'OK', '2026-06-29 18:43:14.043441', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (680, '1fcd1dbc6ada4349a8a09a99601d55fa', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 10, 'OK', '2026-06-29 18:43:15.033780', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (681, 'f09665195f08433ca3784f9e6a1d5347', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 11, 'OK', '2026-06-29 18:43:16.308099', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (682, '57a568721b1a4ec7b49cebfde9a252f7', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 21, 'OK', '2026-06-29 18:43:17.453346', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (642, '28bf0c3ed2c941b2942d672bed1767e5', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', false, 261, '用户名或密码错误', '2026-06-29 18:38:15.105252', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (652, 'db97badf50a4439d9e15e705654611a6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 8, 'OK', '2026-06-29 18:40:19.201789', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (656, 'cdcb23727f69481bbc76a4ee6b04093a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 468, 'OK', '2026-06-29 18:40:31.044801', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (662, '46bd4d0120844629863ef60fea9a35fe', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 61, 'OK', '2026-06-29 18:41:17.337455', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (666, '1496883c832749e4b2e2aef44f0f50de', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 38, 'OK', '2026-06-29 18:41:24.217733', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (672, 'cb18528ae559421ba20a5834a4cedfaa', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 8, 'OK', '2026-06-29 18:41:40.670257', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (676, 'ffb9781aa9d445f6a1bf0b86244db6cd', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 6, 'OK', '2026-06-29 18:42:21.431865', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (677, '25cbea5088f1472bad3ccead2003a7f8', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 18:42:21.450888', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (678, '2116fe6a2a1649608a170006172f4926', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 16, 'OK', '2026-06-29 18:43:13.046818', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (684, '7734700119504c24a728e60517dbcac4', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 20, 'OK', '2026-06-29 18:43:24.700314', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (688, 'abfa684092a741f0970fd10b974f204c', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 23, 'OK', '2026-06-29 18:43:32.543528', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (683, '791ff07e380f47d69dbbb0287f6fe29a', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 52, 'OK', '2026-06-29 18:43:22.866693', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (685, '17201a1a511145ad9692ebaa10a12880', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 19, 'OK', '2026-06-29 18:43:28.155745', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (686, 'd79684ed084041bcb41aba504d6bba5b', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 23, 'OK', '2026-06-29 18:43:30.093424', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (687, '87e80e5cd06f4df1a3aeb13259814583', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 17, 'OK', '2026-06-29 18:43:31.538607', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (689, '58c3e44b79124260bb638673f21eb2cd', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 18:43:38.225149', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (690, '914c65b46c2b4a708b4e055298378b3e', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 8, 'OK', '2026-06-29 18:43:39.633964', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (691, 'ff2e1cfd47a34b2c98dc1278d0e20536', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 8, 'OK', '2026-06-29 18:43:39.870089', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (692, 'e37ff54dcb494a7490ee66ebeec6d490', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 6, 'OK', '2026-06-29 18:43:40.268864', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (693, '0abe8da37c0f4e9c86d1660b9ee071dd', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 31, 'OK', '2026-06-29 18:43:41.428765', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (694, '50a73a4473ac44018673baa6baee4b50', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 18:45:28.598290', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (695, '58de4e158efb42af966e27d1955ffae6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 43, 'OK', '2026-06-29 18:45:28.900746', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (696, '957aea73c9bc4cd78af9274e1c5e9862', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 5, 'OK', '2026-06-29 18:45:30.700909', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (697, '9f9b98555ce845e28a268e1e0972b8cc', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 6, 'OK', '2026-06-29 18:45:31.048103', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (698, '3f3f07bd1ab8454c9a566c1d06c87764', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 15, 'OK', '2026-06-29 18:45:32.472897', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (699, 'f7242082481a4fa8839d2383d31cc4b9', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 10, 'OK', '2026-06-29 18:45:32.832232', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (700, '82fc496262444ef0a72261078371777f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 10, 'OK', '2026-06-29 18:45:33.668117', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (701, '418bb66e5be549e6b4bd80150cc5bb20', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 54, 'OK', '2026-06-29 18:45:34.063056', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (702, '6c314d5113534fa2893ea991aab6ebce', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 7, 'OK', '2026-06-29 18:45:34.591214', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (703, 'b1dc89ae36f44c6cbb1badbfb1efda9d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 11, 'OK', '2026-06-29 18:45:34.933887', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (704, 'a692b3a381bb486b87e816eb87aa693e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 9, 'OK', '2026-06-29 18:45:35.482204', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (705, '1a9fe382a3bf49f7ad676eed301a537a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 9, 'OK', '2026-06-29 18:45:35.849224', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (706, '2499a988d2604e5393a8c8236b962475', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 7, 'OK', '2026-06-29 18:45:36.632964', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (707, '09477e28c61e41c9996f89e1c806138e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 7, 'OK', '2026-06-29 18:45:36.990410', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (708, 'ea067ed305e64cf3a34b405c148d6abc', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 6, 'OK', '2026-06-29 18:45:38.409463', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (709, 'ec1d41f716e042fabededa9f9fb770ca', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 9, 'OK', '2026-06-29 18:45:38.773119', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (710, 'da8f052e175c46b7adeac63e89f8179a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 12, 'OK', '2026-06-29 18:45:39.347778', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (711, 'f6846b2012f546048bf85933a4d4b9ad', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 9, 'OK', '2026-06-29 18:45:39.692711', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (712, 'ba3bc16854e348558169c19b26212ffb', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 9, 'OK', '2026-06-29 18:45:49.690142', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (713, '73f28af7089f4b85885058b864060cd9', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 13, 'OK', '2026-06-29 18:46:09.832445', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (714, '7dcadc631c0f4a0a9d8c2d4554aaa49e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 42, 'OK', '2026-06-29 18:46:10.123919', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (715, 'f3cfb15024b04258827f671216d8689f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'handleAlert', '/api/v1/greenhouses/alerts/1/handle', 'POST', true, 66, 'OK', '2026-06-29 18:46:18.245364', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (716, '4f7dc3d68fe44c4a8d06426df4fb7fc8', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 99, 'OK', '2026-06-29 18:46:18.695774', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (717, 'cca262986515413d835975f5980b52a6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 6, 'OK', '2026-06-29 18:46:23.698539', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (718, 'b162cfc8966a4453865cdaa423b3081c', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 12, 'OK', '2026-06-29 18:46:24.059531', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (719, '1e99e2584f494c64992e62c5fe5d09ed', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 9, 'OK', '2026-06-29 18:46:25.310306', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (720, 'de35575cf5eb4adba4c55f686ef97990', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 37, 'OK', '2026-06-29 18:46:25.682672', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (721, '1de99012e92f4f94be9ec14145c5047a', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 23, 'OK', '2026-06-29 18:46:47.755958', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (722, 'a8580d9e040b40c58e0abc5d894d2f72', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 18:47:33.564465', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (723, '078c605ef04346f5bbf4364e0030df17', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-29 18:47:33.600633', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (724, 'b9aee13638dd4e22be7e0766c8efd537', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 8, 'OK', '2026-06-29 18:47:56.374982', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (725, '7ab15b54dd054777aa1153f2664d7763', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 23, 'OK', '2026-06-29 18:47:58.757798', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (726, '0e702ee1469945fb87f9124077f93629', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 25, 'OK', '2026-06-29 18:48:05.269177', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (737, 'fd3981324c1a4725afad8a13e27d9299', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 21, 'OK', '2026-06-29 18:49:41.728368', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (743, '66bbe7bcf7b64d118567ddd081c828a1', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 24, 'OK', '2026-06-29 18:51:10.164975', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (747, 'adb57839b3ee4788914688a65d3a9971', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'feedback', '/api/v1/users/feedback', 'POST', true, 15, 'OK', '2026-06-29 18:55:13.838322', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (766, '023b756575fb4cada55e54bed198e66d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 19, 'OK', '2026-06-29 18:56:46.691113', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (767, '01099e2529ee4f76a4137d6aaa6edaf8', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 13, 'OK', '2026-06-29 18:56:47.047039', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (770, 'e36181971cf84b84a9a02c88eb03ea78', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 61, 'OK', '2026-06-29 18:56:47.586102', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (776, 'b966224ac77443f5b6e7f09cc878c833', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 11, 'OK', '2026-06-29 18:56:52.584892', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (777, 'b4a6e5fd65c647259e479e631a488cd7', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 50, 'OK', '2026-06-29 18:56:53.034760', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (783, 'c14e5f7cd2da434783fcb437c178b46a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 46, 'OK', '2026-06-29 18:57:15.036245', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (727, 'abde168f73974ee1809e98eb84ad8d04', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 29, 'OK', '2026-06-29 18:48:06.299382', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (728, 'b9b533f361af407a843aaea06e3c6118', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 26, 'OK', '2026-06-29 18:48:07.772785', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (736, '53bac52c156d48cb916f2f394836a159', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 40, 'OK', '2026-06-29 18:49:38.350875', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (738, '92b923f37cbe4103b7473aebd03ff0d5', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 16, 'OK', '2026-06-29 18:49:44.136413', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (739, '694b3dd118464c0cbe4e43edef8eded5', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 26, 'OK', '2026-06-29 18:49:45.209494', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (740, 'dd31786abd574dd9a634c0d3d8f33462', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 67, 'OK', '2026-06-29 18:51:04.332281', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (741, 'c3a4f74713b948df8f02019f2de5c2cf', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 17, 'OK', '2026-06-29 18:51:07.556315', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (742, '50e79d799c0e4c4aa95383c055a6ae12', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 34, 'OK', '2026-06-29 18:51:09.021451', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (744, '4f0956ee974740b3bfd2c86b6a605899', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 18, 'OK', '2026-06-29 18:53:41.850868', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (745, 'bf9f228b446c4883be33d70b6a0bd1a2', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 12, 'OK', '2026-06-29 18:54:30.388491', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (746, 'aa502fe1f62f443f815ffd75afd96b79', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 200, 'OK', '2026-06-29 18:55:05.426308', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (748, 'b0b06ab59d8d4fd5bc845fa50f19e9b1', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 318, 'OK', '2026-06-29 18:55:28.221089', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (749, '25c1477fc0e7493bb844441449c173f0', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 140, 'OK', '2026-06-29 18:55:28.804170', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (750, '106273a6b8804e2eb615911070cb414e', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 38, 'OK', '2026-06-29 18:55:29.873284', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (760, '93a202d190fe4d0b83b9dd33b4b08054', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 8, 'OK', '2026-06-29 18:56:37.631450', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (765, '12333d06600447c7b7d144554b8a511b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 23, 'OK', '2026-06-29 18:56:44.184384', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (768, '7cfac121582543a19ab0dc5703c89696', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 104, 'OK', '2026-06-29 18:56:47.067777', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (769, '2073fc897a7241569f9ded059c07cc5e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 9, 'OK', '2026-06-29 18:56:47.281676', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (771, 'b32d371c05f04e23b8dbf84653508030', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-29 18:56:48.665658', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (772, 'b90370242a0640e2861d9601c49cb033', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 41, 'OK', '2026-06-29 18:56:48.935726', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (773, '93a4e0ac1c7a459faec9a196e44d1662', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 18:56:49.011859', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (774, 'd8a6e58cbcfb4e76a9cb14afc98bc15f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 17, 'OK', '2026-06-29 18:56:49.057027', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (775, '227e7a67b7da45f5a524c0558985f61f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 69, 'OK', '2026-06-29 18:56:52.392981', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (778, 'ed969c41c4f54dea941ed9921a9163d7', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 65, 'OK', '2026-06-29 18:56:53.339893', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (779, '3ee3b60b74e7471592961d15200bb36e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 42, 'OK', '2026-06-29 18:56:53.723390', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (784, 'ffd755649ceb4d83a809c7deb56fdecb', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 29, 'OK', '2026-06-29 18:57:15.872733', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (785, '30664ac484874d4b8d4f5cd7ef480678', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 110, 'OK', '2026-06-29 18:57:16.232676', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (786, 'ab8680f535504ef9a5bb36752de33ad4', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 7, 'OK', '2026-06-29 18:57:33.604677', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (788, 'f6a5a1821c614654acd368c94cf5285e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 120, 'OK', '2026-06-29 18:57:35.121097', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (729, '8372dd6112d44a26802ddd7cec3c9dd2', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 18:49:34.017766', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (730, 'f04e21e60afa4b95ad985e58491940f2', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 18:49:34.280689', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (731, '909cd86eb0de4d83903c516d6e2fc66a', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 18:49:34.490677', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (732, '2c65a0aab0d34c0e9c27c46d4fa9fcfe', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 6, 'OK', '2026-06-29 18:49:34.833346', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (733, 'a14fa38a6a724da1baf840b0ab47dd98', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 18:49:35.218644', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (734, 'e2811b20a6aa4f50b280041cf0e0b9ad', 'CM+', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 1, 'OK', '2026-06-29 18:49:36.439461', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (735, '6fdc36d01ce94c3cb478a2b42ddaaf0a', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-29 18:49:37.360557', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (751, 'c1873cea026c4966b491c19d6971b473', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 83, 'OK', '2026-06-29 18:55:32.730787', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (752, 'db1788cdb3cb4aaa8178f811f875cf08', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 18:55:32.799972', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (753, '82bc4ffc59dd416fbbf239f02a7c0616', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-29 18:55:32.818675', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (754, '56ac6d45027e40c982398515ca1b4106', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 147, 'OK', '2026-06-29 18:55:32.969469', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (755, '554947773e9a42d0bf69813171680654', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 18:55:32.980891', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (756, '4e426f06b5e94abe8d251151eb9d6a43', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 1, 'OK', '2026-06-29 18:55:43.726808', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (757, 'e0fd63c2a14e4227afb3a654e5d4dae6', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 61, 'OK', '2026-06-29 18:55:58.130742', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (758, 'ab64df55fb5c4bf88b0c9ca141d9c8e9', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', false, 1, '当前账号无权访问该大棚数据', '2026-06-29 18:55:58.163860', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (759, 'f5248ee8b47c4f5395a214c0c83bc6a4', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 63, 'OK', '2026-06-29 18:56:19.248757', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (761, '14bb610f2a334d91b1f7b8cf3751deeb', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 18:56:38.341966', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (762, 'e91ac9b5eb0947d1acf7aad70d10b667', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 18:56:38.945644', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (763, 'd682832029014ab1a74d0b6e39cdbcb3', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 1, 'OK', '2026-06-29 18:56:39.278152', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (764, '6460564a9d26442f891302602e1abb16', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 18:56:40.636717', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (780, 'ff9733ce191b4407be0f31e9b5a3e106', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 126, 'OK', '2026-06-29 18:56:57.560447', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (781, 'e49997aac80a4cb592bed32f5677d948', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 18:56:57.657581', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (782, '75aa905ce1364ab591f4ca8875929517', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 26, 'OK', '2026-06-29 18:56:57.689763', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (787, 'e78616a8b60244c99a04019be6ba69b3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-29 18:57:34.548568', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (789, '0757a6f6a7ee4248bc5d70d8e8f99bfb', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 18:58:03.203191', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (790, '46de1a9d17584b23812c9b8beef8cf19', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 8, 'OK', '2026-06-29 18:58:03.208745', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (791, '10cafccdaa274acba58919c64075bbb5', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 18:58:06.070387', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (792, '53db1a07dba24e01a0df800fdf27ee0d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-29 18:58:06.418700', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (793, '008e19b635b54acdaad5c4424e4b0fe2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 3, 'OK', '2026-06-29 18:58:13.164665', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (794, 'cf68c5e78e824d32845aa885eb864904', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-29 18:58:13.491607', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (795, '7ee09f364d2b498fb66d11ec9a1c32e2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 3, 'OK', '2026-06-29 18:58:16.773132', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (796, 'ab52f7653cf04a8c82a2a22d41faa702', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-29 18:58:17.109774', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (797, '59ee69e826d74e718befe4a7f25a984f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'command', '/api/v1/greenhouses/devices/commands', 'POST', true, 1, 'OK', '2026-06-29 18:58:18.103683', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (798, '8f00ec3e553d41d48fbd157537ef30f3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-29 18:58:18.425195', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (799, '9735df2272f141bc8ee1efe46ef48f1f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'updateDevice', '/api/v1/greenhouses/devices/1', 'PUT', true, 22, 'OK', '2026-06-29 18:58:42.005304', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (800, '7c96947209d34399b379320ccc7be08d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 18:58:42.341557', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (801, '789d3b6184c14dc9b300239d76833336', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 18:59:18.570344', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (802, 'e86cd0f3c0014af7ad3cb173cba24384', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 5, 'OK', '2026-06-29 18:59:20.379592', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (803, '83bd15ddcbfc4036a6f49f4edcad791a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 18:59:27.209241', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (804, '039585e0581b41d1a0d28c595bf26dda', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 5, 'OK', '2026-06-29 18:59:27.541450', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (805, '5d23871de0c24f19b55b7413865d7ebf', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 18:59:33.204090', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (806, '716be6627f6945868ecbee0eaf1e0061', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 10, 'OK', '2026-06-29 18:59:35.351499', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (809, '0ffea9035e324a14865a8cd0f755a18a', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-29 18:59:59.050314', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (807, 'e6d34073ad66445fa6034059830685f0', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 18:59:38.646104', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (808, 'dabf8e081e53437b8b60de8f9184281c', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-29 18:59:49.966155', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (810, 'c30460a5592c4ad986c413b89aa20a08', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:00:14.913701', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (811, 'fa7e8afa9f324a33adbdccef8bc13ec3', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 3, 'OK', '2026-06-29 19:00:17.307976', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (812, 'a661defc0d5f4a2e903f501a37057d3d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:00:19.890429', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (813, 'd02cf2a4e0034bcd8992d7cd5e25b130', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-29 19:00:26.230474', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (814, 'cb14165db6694b44ac98c921ac161e8e', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 19:00:29.152667', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (815, '0bb5395c8aa949408a206e87c3c64b41', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:00:30.797532', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (816, 'c70c186b398e4b6284c0437dc4d7ff4d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-29 19:00:33.601284', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (817, '4b76c2a70a3e4ecd8b9753e3ff634f94', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 19:00:36.526943', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (818, '765d883c76c14e9e999ab68bbc2fbfa5', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 19:00:38.134393', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (819, 'a0a16903373c4c149d17506938684faa', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 3, 'OK', '2026-06-29 19:00:41.984979', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (820, '5ca8cc0373a348159c6c689024061c14', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 5, 'OK', '2026-06-29 19:00:44.032229', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (821, '0142fc4d6b5649b3bcef5f0e97bdd180', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 19:00:48.955496', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (822, '37cb6260d8444c9dbd4fcc37b4241ac0', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-29 19:00:49.282743', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (823, '7d5fafad3f6b4d28aa133ef3e327aaee', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 19:00:51.348097', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (824, '1bf9631dc97c4938888fe1bac6472f47', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 3, 'OK', '2026-06-29 19:00:54.725022', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (825, 'e6c507e1ecde434ea0e67e2a3c899f79', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 8, 'OK', '2026-06-29 19:00:57.828691', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (826, '3db90a99a87e445089d7320dde0fcab3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 10, 'OK', '2026-06-29 19:00:59.270177', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (827, 'f768e45a9299447b9c9254515cb5970c', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 43, 'OK', '2026-06-29 19:00:59.673829', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (828, '427d88852a1c4c9aa2f06ff15ba1dc79', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 14, 'OK', '2026-06-29 19:01:00.829382', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (829, 'e783a7970443404db00481de91dd755f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 31, 'OK', '2026-06-29 19:01:02.003849', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (830, 'f779f979dd1c4aa2a8fc0d63d58ce7e5', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 88, 'OK', '2026-06-29 19:01:02.321889', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (831, '485c0670855340dcb2140a97c3920e5d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 17, 'OK', '2026-06-29 19:01:07.645836', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (832, '725aa04438544cae81a62784e4272b8d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-29 19:01:28.263740', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (833, '7462090beb784a1aa6b1beefd6b21be5', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:01:29.212896', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (834, '3afd916406e049a4a59c59ccfc6303d9', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 5, 'OK', '2026-06-29 19:01:29.482029', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (835, '778ef4b8a641453083dc4543efe41d11', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 19:01:29.541250', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (836, '77fd8f851b314796b845f5ac9d08c4a2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-29 19:01:29.586719', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (837, '9bc8cfcaf2fb4e198fda055442a0cbe6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:01:29.882000', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (838, 'cafca68438f34d8a81131153798cf565', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 19:01:30.005178', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (839, 'c871635a153245aab62d48dc73d73249', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-29 19:01:30.107413', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (840, '3b27160545cc467b9bc5beaf6eb2bbbe', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 19:01:30.967196', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (841, '21c2e6aef29143cbb1617a1d7c6da4e2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-29 19:01:31.237949', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (842, 'bf5b7472f29147358f8e85758489d25e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 19:01:31.312449', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (843, '8c96c5cb35ee478d9edcae9c0416a3f1', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 19:01:31.417824', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (844, 'f92b70053ff443a7949974e5d486e3a6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 6, 'OK', '2026-06-29 19:01:33.633304', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (845, '77c15b7bc6c64dd1a3ecf8ed25ba317d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:01:33.945133', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (846, '0a50eaa11688457fb6d25839a08ef98e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 175, 'OK', '2026-06-29 19:02:35.462996', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (847, '429bf8c515024619a14a0b5dd4598b06', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-29 19:02:35.846769', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (848, '32f1e49600ad47cb8ef9a554b275f8fb', 'CM+', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/3/profile', 'GET', true, 1, 'OK', '2026-06-29 19:02:43.634518', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (849, '506e61e382b642c2a4c7f935f9c047f0', 'CM+', '0:0:0:0:0:0:0:1', 'UserController', 'updateProfile', '/api/v1/users/3/profile', 'PUT', true, 3, 'OK', '2026-06-29 19:02:48.611039', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (850, 'cce04d69ce2740ca84dcfe0a8a428ddf', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', false, 10, '当前账号无权访问该大棚数据', '2026-06-29 19:02:54.039427', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (851, '6883db0c016f44d285d93d3f7cfec9ae', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 8, 'OK', '2026-06-29 19:03:00.663936', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (852, 'a205ca520cca4898b58a04cee9ede206', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', false, 1, '当前账号无权访问该大棚数据', '2026-06-29 19:03:00.878485', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (854, '1760b8403d7c4006bf602c29853cde76', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:03:03.581056', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (855, '48cd7d58e8c3435a9d31558467bc6699', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 1, 'OK', '2026-06-29 19:03:03.834154', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (857, '172aa14225314588826b5c2d00a6645a', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 1, 'OK', '2026-06-29 19:03:08.248894', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (862, '055bccfef3274e748bfcfa001a3d44a5', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 159, 'OK', '2026-06-29 19:03:49.819857', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (863, '1bc49786a49b4a2596feebd349f8d9da', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 17, 'OK', '2026-06-29 19:03:49.944342', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (864, '90f902d8b20e4049b1aeb5e3f03f7745', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:03:50.193721', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (865, '59b59db939db454c854cf60e596ffb5a', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-29 19:03:52.479435', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (867, 'c56f541c55994f8abfbbc808b993e9fd', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-29 19:03:54.968781', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (868, '8ab4d7e01b7a462d9c1fdfdc5c4ef78d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:04:02.865052', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (870, 'c7f1c43c902e4dfe9703dc96e3ad9419', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 6, 'OK', '2026-06-29 19:04:06.662511', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (871, '987fecf97d77411b907d4b3e1573fdbc', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'updateGreenhouse', '/api/v1/greenhouses/3', 'PUT', true, 12, 'OK', '2026-06-29 19:04:37.402812', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (872, '3e0bf215df1647dfae0329c5e96836c2', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:04:37.746979', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (874, '28257cecbc05440aae2b4aa644b0e253', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:04:41.572500', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (875, 'd2b94c06fb8c4a5b93145ecbe27e4419', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:04:52.751140', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (887, 'a2a50c6ef87a40d4bab1f1eefa3b8a85', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 10, 'OK', '2026-06-29 19:05:47.336688', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (888, '6fc78dab4a2d4e02ada55c0de6bd851a', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', false, 49, '验证码发送过于频繁，请稍后再试', '2026-06-29 19:05:53.307849', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (890, '2c483a8b489b4a5f8d206ad4a1dce66c', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 193, 'OK', '2026-06-29 19:06:59.961319', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (891, '799603da358544eb8eeb28daf881514a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:07:00.041515', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (893, '969a5a60230d46d9a3c188de51e5dfe2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:07:06.302315', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (894, 'a788ba816ffd4731ba26a52345e33345', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 19:07:06.335671', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (896, '8a005332b7ce4b7ba1927063847380c4', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:07:10.247840', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (897, '65d2f880e97b47399698ce2f91c63554', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 178, 'OK', '2026-06-29 19:07:10.764501', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (898, 'a08c311902a64e1e8db709beae7489b9', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 5, 'OK', '2026-06-29 19:07:10.924980', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (900, 'a4932bd0ae8f4c06acfd03b702a40e55', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:07:11.042941', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (902, '996a94f0712e45478d47e292a380b6dd', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-29 19:07:20.119838', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (903, 'cbb317a56a92484581e389197a79f99a', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 19:07:28.582499', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (904, '4250d2890bc14028ba4299e57a118461', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-29 19:07:30.755515', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (906, '06e11828fdaf402486f9dcc0b410b81a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:07:34.777815', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (907, 'c7e99d1381ee4dfcb30e239f7037d113', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:07:34.810212', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (908, '33fd9dd5c385456ca4999336d23e9fbb', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 2, 'OK', '2026-06-29 19:07:35.929716', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (910, 'f5d005d4f5fc4b788f49397111291f71', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:07:36.429840', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (912, '8a572879cc9a4212a0678d9112f970bd', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:07:37.728167', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (913, '293eae24022445ceb40b22e8a467d82d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 0, 'OK', '2026-06-29 19:07:39.556634', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (914, '771be8b1cf674b3e9109db42d73350f5', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:07:40.356840', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (916, '5c4e620d82ff4e738b1ddfaf5f997d2a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:07:41.069024', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (917, '12c8377958594638a7584cfb888043ae', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:07:41.488491', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (920, 'ccbeb40771d84b0995c8b03b1445afd1', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 6, 'OK', '2026-06-29 19:07:47.331335', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (922, 'eac1b3b177574fc9be775760b0f6e2f6', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 0, 'OK', '2026-06-29 19:08:09.377263', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (853, 'c2d29396e30045d8b7ba876abf6970fe', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 1, 'OK', '2026-06-29 19:03:01.185438', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (856, '046ea54954b54c7f90576a045951272b', 'CM+', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:03:05.836235', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (866, 'cd66eca2e21d4be788e9be463839fe24', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:03:54.962635', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (869, 'd7a1c975df664f4fa3e47f82b877eb6d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:04:06.658889', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (873, '9d749a23df814b7da185331462b083ad', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:04:37.750322', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (877, 'a8da2b572782448c966cc70551a9ccf0', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 35, 'OK', '2026-06-29 19:04:55.576486', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (892, 'b781d544d7ea49efac663540a4b28840', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 19:07:00.043019', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (895, '7c915ace20094a6ab2a24187f4e3148f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:07:10.209567', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (899, '771da632734c453b9d91197af22b37bd', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 31, 'OK', '2026-06-29 19:07:10.934016', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (901, '1674c9b0bb054d888987c30564337d17', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:07:20.088275', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (905, '4aacdfa478ef4f158ffe606b15cb5177', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 5, 'OK', '2026-06-29 19:07:31.475365', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (909, '39f37563fa3643f488735c9682ada95f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'createGreenhouse', '/api/v1/greenhouses', 'POST', true, 5, 'OK', '2026-06-29 19:07:36.412054', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (911, '31744c90ab344bc988fe7e7e7df4d5b3', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 6, 'OK', '2026-06-29 19:07:36.754210', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (915, 'dfd66ff73979400c97e15312312e7a27', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:07:41.014044', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (918, 'd0d13dd8640a49039063878a37215e0b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:07:41.491069', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (919, '200ee4846d014c1288f70cf254b116eb', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:07:47.326582', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (921, '8608efface524722ac5a6e70ce96beb4', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 126, 'OK', '2026-06-29 19:08:09.341904', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (923, 'e2eae7bd5aa84c82a84c7367b6ee90d2', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-29 19:08:09.615789', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (925, '26381fb2db29448698ab8ed94f632f46', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:08:11.324929', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (928, 'd7fc7e3f8f954aac9c27bf0aeead71e6', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', false, 1, '当前账号无权访问该大棚数据', '2026-06-29 19:08:12.325849', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (929, '5b1289f402be4aadb8cc664a305bcb4b', '20246144', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/4/profile', 'GET', true, 0, 'OK', '2026-06-29 19:08:12.837802', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (931, '375e4bc531bd49db858a0ce013e4b050', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:08:16.952659', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (933, '82b5052ab6714b86b2b734302a7cc738', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:08:17.608769', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (935, '14ea6a95eb394dc2b41cda49e0dafef7', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:08:20.753192', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (858, '1ef3ce5a16e84017a315616ebe66bd2c', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 73, 'OK', '2026-06-29 19:03:24.292528', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (859, '4980fdb970ad47c8bd698ebf81839476', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 11, 'OK', '2026-06-29 19:03:24.808392', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (860, 'd91bcb16d9b54306851b7d2fb1e3024b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 16, 'OK', '2026-06-29 19:03:25.151889', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (861, '41044cf164ad4d0389d70b0de61fbf34', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 7, 'OK', '2026-06-29 19:03:26.465512', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (879, '68dd648f8a18475d8464dcfbc17cb652', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 70, 'OK', '2026-06-29 19:04:59.582459', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (880, '9e0bd0250dcc40a7818d6d71249c03d2', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 7, 'OK', '2026-06-29 19:05:00.190772', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (876, 'b286a44ef75c482d8ac6ff77d208558e', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 13, 'OK', '2026-06-29 19:04:55.032951', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (878, '42eeccbd643c43deb3724c2646e65df6', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 11, 'OK', '2026-06-29 19:04:58.497467', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (881, '7656d5b0e5b143939f6bb39fcd62fa51', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 13, 'OK', '2026-06-29 19:05:11.317557', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (882, 'f3404a91aba04c6cb40a909710339346', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 51, 'OK', '2026-06-29 19:05:13.576838', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (883, 'c856962e06d74460af4959ef05cc9d62', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 38, 'OK', '2026-06-29 19:05:20.881527', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (884, 'e901f1eb44b84109824bb59ef0eca556', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 30, 'OK', '2026-06-29 19:05:21.474683', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (885, 'c5cbba4aa6b9482da4fa91f58901c60a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 9, 'OK', '2026-06-29 19:05:33.353686', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (886, 'b65aeb99e7ef47049e01f941000687a8', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 12, 'OK', '2026-06-29 19:05:33.589755', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (889, 'dfe2decd88924b3ea3e50b935b461808', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 50, 'OK', '2026-06-29 19:06:14.786581', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (924, '9ec4c4fe17fe4bc58a6dde3754d6ed9f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 28, 'OK', '2026-06-29 19:08:09.619126', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (926, 'c6a341d93a0f40f283f14180aa518eeb', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:08:11.869257', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (927, 'f8070bd877384768adcf5e85f46b8d89', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 19:08:11.908660', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (930, 'a3dad25b695b4ea283fc7a9fc4005f87', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', false, 0, '当前账号无权访问该大棚数据', '2026-06-29 19:08:13.436503', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (932, '0f090178f7dd491f8fd61765e653f8f3', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 1, 'OK', '2026-06-29 19:08:16.977109', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (934, 'f68b7fc75d8740ad96ef1563c525b904', '20246144', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 0, 'OK', '2026-06-29 19:08:18.041322', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (936, '0435b94a316d487a85b1fa2f49a0dbff', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 19:08:24.038434', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (937, '1d0cf17161174e8cb6d79e67bca01027', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 127, 'OK', '2026-06-29 19:08:37.671974', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (938, 'e71c1c0a7ca4496e88bc4d769bea144e', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:08:37.746151', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (939, '7daa72eecf634c1bb06378f920b8eaac', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:08:37.747233', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (940, 'e820e7194f6c4972a93b7ea6294bf738', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:08:56.907536', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (941, 'c346d08279a54f7aaaff90bd00e0b6ff', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-29 19:08:56.908341', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (942, '186b04d3bde34d0f88fcb2dae36170c8', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 63, 'OK', '2026-06-29 19:09:52.450385', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (943, '7c5d861670804f27b664fd480ff1c375', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-29 19:09:52.501974', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (944, 'c639845533684c78b0e78889c41d07fa', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:09:53.892164', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (945, '529a24770296487e8caf1e672e6de882', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 19:09:53.917579', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (946, 'ad168f6d4a374e8e97f43adecdaa346a', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 19:09:57.582902', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (947, 'e2679cc68384495798431176b61c52d4', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-29 19:10:06.164130', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (948, '26ec44ffc9804574bd5cf98eb82e964a', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:10:16.456794', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (949, '335292b067294edf95e8aa368a499310', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:10:20.749139', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (950, 'ac089c721ef14ea98a30f5acb0b9da68', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 19:10:22.791436', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (951, '1415e940af1e493e80657989239a7381', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:10:30.791045', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (952, '5f47d7afeca64af5b3924521587511be', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 19:10:30.988630', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (953, '35896829cb71458184c3c158f79533fd', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 19:10:37.527266', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (954, '5c4518c82d0245d1b564d2204265e3b5', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 0, 'OK', '2026-06-29 19:10:41.423148', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (955, 'f9d39cf519264c8295ac33c15f92d340', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:10:47.769396', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (956, 'f15a2e84a9e54897af416e11461b8213', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-29 19:10:47.825107', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (957, '71c074b421374a4ba87701573433ee42', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 1, 'OK', '2026-06-29 19:10:48.450226', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (958, '5c0b64a1dd024e37b950259b17e39540', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:11:13.256778', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (959, '9fa71172cc854876bfbe991244a8fe7b', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 19:11:13.316978', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (960, 'a762d858bea340f2832f8992e6a5af9d', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 2, 'OK', '2026-06-29 19:11:21.188900', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (961, '1e46a03ad11042b1b2bd8373d7731127', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 59, 'OK', '2026-06-29 19:11:32.869610', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (962, 'd372bf342aa74d85acd700675450c8ac', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:11:32.970964', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (963, '3af48f6f9c844d8cb1970b469fa3193b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:11:32.972608', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (964, '34133084fe1e41acb3881ba1b03ef7ae', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 19:12:11.010418', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (965, '05012b17d36c4d42971509710f0b878a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 5, 'OK', '2026-06-29 19:12:11.014575', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (966, 'f36798650da44e61880863529091dc59', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 0, 'OK', '2026-06-29 19:12:15.443424', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (967, '1b5c04449bf945e89458fee196d011a0', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-29 19:12:15.452242', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (968, 'b5292ed8bd3d47909c07b165811f2971', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:12:17.226677', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (969, '2d07729a2be3412aaa3ccddca98b4d53', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 8, 'OK', '2026-06-29 19:12:17.234814', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (970, '3d3f6a259c5e41dfa28b624153ef80c2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:12:36.532953', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (971, 'c98aa24edac8469293bc4f0e51fcd38a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 19:12:36.644919', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (972, 'f3ba6b6cb6cd481dadedaeada2fb85b3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:13:51.219850', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (975, '249f178212df42529ea247ed54a47647', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 19:14:41.381668', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (976, 'f83d4d7b93564ba18a042ff7e82368d1', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:14:56.913838', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (977, 'fe5ad3a297314401be3c2e1a4fc78e27', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:14:56.922541', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (980, '4fde3b547966491ebed7e44f265f1b52', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 13, 'OK', '2026-06-29 19:14:59.370305', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (981, '1e0dc055a90c48df822d595e8f6bff46', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 6, 'OK', '2026-06-29 19:15:11.705921', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (982, '3eb1c45f5a9b464aa3aa38adeb575686', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 8, 'OK', '2026-06-29 19:15:11.745961', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (985, 'f60fd2d9acff4d43b119c5c74294025d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 19:15:44.797716', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (986, '41c5d5478cd5437ba3f512508d8e6faa', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:15:44.834925', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (990, 'efb04a8171d9433089c28af25db9af30', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:16:43.451107', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (991, '983cd926fd444d368c039ac2004aa47f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 8, 'OK', '2026-06-29 19:18:38.781583', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (992, 'b9219d53c8a24e0baac120b577bc0edb', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 8, 'OK', '2026-06-29 19:19:46.811881', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (973, 'a18506d87e3c4b3b88c106f51885c509', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-29 19:14:01.460488', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (974, '7530bcfeff414355a3c07dfbf7fed9ca', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:14:34.788375', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (978, '9c456f57caee4f6ea7e57e764f468aec', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 19:14:58.236452', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (979, '6523abecc2554292be6c2ce5f6bba73c', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 10, 'OK', '2026-06-29 19:14:59.366240', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (983, '1a8647363a5a424f92edf23196277dbc', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'updateDevice', '/api/v1/greenhouses/devices/1', 'PUT', true, 3, 'OK', '2026-06-29 19:15:33.209810', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (984, '962d52866a5e40e9970d9a8c76d770e1', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 19:15:33.491442', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (987, '4dccc8ac1c9a474482f14a2e53efff3b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:15:44.836998', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (988, 'fc0f60d48f37409e8deed5884717a39b', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:15:45.638730', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (989, '4ecec86ccade4a53a5f4423ea9c40bf8', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 19:15:45.686686', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (993, 'e1cb9e49c15b4ab1939c26c1b862da2d', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'sendCode', '/api/v1/auth/codes', 'POST', true, 6802, 'OK', '2026-06-29 19:24:11.228522', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (994, 'f4b7b1e68a4e43cfba4c19df44bf5de8', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 6, 'OK', '2026-06-29 19:24:28.355770', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (995, '77ccb9c400444fd680327e5cc16effb1', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 27, 'OK', '2026-06-29 19:24:28.376638', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (996, 'cef6dee66c2e4ad1b5a9597f1b720bca', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 5, 'OK', '2026-06-29 19:24:29.492492', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (997, 'bc03a7248d254494865787b75bd35268', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 11, 'OK', '2026-06-29 19:24:29.565733', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (998, '53b557018fc24ba0b741cf3869935eec', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:24:29.944212', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (999, '01512624980d46949057c5c31dcedbdd', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 19:24:30.056842', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1000, '67fe6c9ab370467fb7dad84f4492ab66', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:24:36.503916', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1001, 'f5ccc93e6b5043d8ab3aa524a309ae56', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 19:24:36.557970', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1002, 'fcf4591ee4db4dfbb5faedb124c21e5c', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 3, 'OK', '2026-06-29 19:24:36.949726', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1003, '9a85ca2b08564511ab7ab5bc0c23a8d7', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 4, 'OK', '2026-06-29 19:24:37.882398', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1004, 'f20ff1ad7a3542188e0b92bce718ad05', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 154, 'OK', '2026-06-29 19:25:08.145135', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1005, '74cffcc2259241c1980cea95ea68c9d2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 20, 'OK', '2026-06-29 19:25:08.236419', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1006, '3ca0c4e35f8040ffa93ad75270266c19', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-29 19:25:08.589143', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1007, '96ceb6b42ad647429f1cc0bb54529482', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:25:42.110142', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1008, '08758092b5ea403a953d267c1d0b93d4', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 5, 'OK', '2026-06-29 19:25:42.382861', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1009, '983f5a893e15404cb61604587073e4e6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 14, 'OK', '2026-06-29 19:27:05.734163', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1010, 'c965f4e4345d40b4bf71dd5110f00849', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 14, 'OK', '2026-06-29 19:27:05.940563', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1011, 'fcf6d1e2a4ff42069c5fda92ea2ce8de', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:28:07.689599', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1012, 'e8ada8c2379d4615b024503fac122b57', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-29 19:29:19.293110', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1013, '28fa242189954bb19a4bc3bc536a75fe', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 17, 'OK', '2026-06-29 19:29:44.458849', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1014, '9dac8e8ac36a4764a64f974aeb59bc9b', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 19:30:41.042013', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1015, '1d287a9a043a4dbda9d944727daf5748', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 19:31:19.074935', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1016, '5d2f1566789544f7add7eeaef2850466', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:31:19.403201', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1017, '16a7af527a54429b843909a2bf480262', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 19:31:32.476445', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1018, '0ad34bdb5c9a4a28927dd3548a44dde8', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:31:35.662058', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1019, '98cb7c627e844ed6ad0898b7ecc7ea5f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 19:31:36.090642', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1020, '94a1e772f4964c0a81e8b518bd3b60df', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:31:36.421173', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1021, '3f1aa707b23542d2ba7be3939b87f2a3', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 19:31:38.070945', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1022, '5b2de5c49a824f6f94e88f6c5352ad66', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'operationLogs', '/api/v1/users/operation-logs', 'GET', true, 14, 'OK', '2026-06-29 19:31:54.421697', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1023, 'f108ef128ec24c40bf0cd7ffc1b3e998', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-29 19:32:27.838880', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1024, 'a7026bd5646d4654b038343ce621e294', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 156, 'OK', '2026-06-29 19:32:41.278645', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1025, 'a05a0bd279644787b587117fc7c75f38', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:32:41.321573', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1026, '917db7ad1d41495ba3eb447421fd93e8', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 5, 'OK', '2026-06-29 19:33:40.121355', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1034, '88d3d459bcc148ba9f3116776ab77df4', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:35:23.277334', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1036, '2efc6b378ff748358aa09f2dcbd30dcb', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:35:30.465647', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1044, 'dc9fa49cf53b49988cf4a63069891d0c', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 19:38:17.065343', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1046, '31057ff9ed71402eb2fa19d3bb75e9ae', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-29 19:39:07.717220', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1054, '17ed579e04154273ad4b8ff5535b62b6', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:40:09.374900', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1056, 'fc6f61fcad3d433382fe50d79ace6305', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:40:52.760804', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1064, 'df07f17722de47fc998af14e40b0c92e', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:41:34.230018', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1066, '37b906a068c341aba0ce014ba643c564', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 5, 'OK', '2026-06-29 19:41:36.852567', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1069, '716246e59f32442db5ccc12c1e79ec77', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:41:48.252338', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1071, '6b3dcaad37244a3ea81bad9bd47c6dff', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 19:41:48.706855', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1074, 'bf39fca5e42a44d9a01ee8e6319fe31d', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 19:41:49.594592', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1027, 'e07305e0f9a84296a0aeaa898a5f315f', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 25, 'OK', '2026-06-29 19:33:40.138034', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1028, '62a88aed215447278efb8e7c99970813', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:34:08.746516', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1029, 'd32fbafa6b7e43158f8d773aabb7ce5d', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:34:08.778819', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1030, '1b92b2da0da14192a5f4a82168824a2a', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 9, 'OK', '2026-06-29 19:34:15.596116', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1031, '89d0fb12059f4a2eb4c51da599f3d81f', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:34:17.531893', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1032, 'b1d28dcddd874a8a976020ccb1b5fb76', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:34:19.108941', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1033, '03680377d0164fc2be97e6fe75210bc6', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 19:34:19.131593', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1035, 'cc7e63565c5b461f955ed8882561bec1', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:35:23.307681', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1037, '9e5daca22ec647719d86d222454b635d', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:35:55.212215', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1038, '53e987be92b943e687fdc3f2c5accc3b', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 2, 'OK', '2026-06-29 19:35:55.244766', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1039, '4f52c537d9d1499fbb8926fe2e2669aa', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:36:11.835375', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1040, '29c6939a1fa640a3b2b174d5cce97f1d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 15, 'OK', '2026-06-29 19:36:12.155522', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1041, 'caf0ac7f4e8b4ecbb930bff1cc46ae13', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 19:36:59.260426', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1042, '0cd104f9c3c84504aaf3036a4e18eace', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-29 19:36:59.601766', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1043, '2e9c8fc2d5af47168ba92ed8553c3e1e', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:37:43.633850', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1045, '67d0772a7b2042748199dcb355db1f0b', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:39:07.650261', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1047, '8c996013102f44568aeecac637679d05', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 0, 'OK', '2026-06-29 19:39:09.355398', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1048, 'b5f7371f4858471a82b370e3b660f559', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 1, 'OK', '2026-06-29 19:39:12.386294', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1049, '70de6123c08643afb2ad8af4ca3d8073', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 19:39:23.258439', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1050, '48eda4c38fb44782b5bc74a26e974d6b', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:39:43.789168', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1051, '41260f4a8e8842298910cbeaaf856a8f', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 3, 'OK', '2026-06-29 19:40:04.759251', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1052, 'e0e2609968a04a83b9742e668941b333', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:40:05.156794', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1053, '3d5c9af2e1db4de9821aea52073f8335', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 7, 'OK', '2026-06-29 19:40:08.716522', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1055, '22bcc7b3f5904b17b204c28080b47e39', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 19:40:38.198323', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1057, '39aa0f3d48c84e75a6c914ea3b3fb540', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:40:52.762838', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1058, '77abe5bdfef3425f81ce653912d03055', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-29 19:40:53.116540', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1059, 'df048060c4914958a82f78044ca3b079', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 19:41:08.427580', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1060, '7e1992ff233443579a1a5b5e23debb85', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 1, 'OK', '2026-06-29 19:41:09.528816', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1061, 'ead1f7b5b150481dbd2f98394af58ad6', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 3, 'OK', '2026-06-29 19:41:11.982383', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1062, 'd0d82a4523ab419daab136813d63decc', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 2, 'OK', '2026-06-29 19:41:13.785911', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1063, '4eb24396ba074cdaa57503319fbc1c8b', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-29 19:41:18.868890', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1065, '780bc77d8d5145ca8a2bd90427e839b6', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 19:41:34.274642', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1067, '9d38b0b244b347f5b1be007eb2288025', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 1, 'OK', '2026-06-29 19:41:38.412126', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1068, '06704011ce8749c786fbcc10251acad6', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:41:48.250378', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1070, 'cbdfab5565f0442b9f4364fae132e285', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:41:48.706616', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1072, '61ae6f1cfdcc4db4bc22ac50c4a5af51', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-29 19:41:48.897160', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1073, '77733d585a094b65ad03682b6c756824', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 19:41:49.508122', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1075, '47025433ea774519b13abfe5fe16d213', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 19:41:50.031948', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1076, '0888c900c5834482a77ad101c2e1e5ca', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 19:46:19.214684', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1077, '7f0c7fa574b14dd5adb5ec26d1d5ab9b', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-29 19:53:28.504179', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1078, '3c337fc4a7f947e6a845dbdea037fab7', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 5, 'OK', '2026-06-29 19:55:38.127432', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1079, '0d087f21ebfb40c9bc9a4d8d967de06d', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 9, 'OK', '2026-06-29 19:55:38.137765', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1080, '3e3c7a5bdac14776addb7caa4a58c7fc', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 8, 'OK', '2026-06-29 19:57:31.349108', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1081, '6b749e221eab47c48229609d4629f2d3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 19:57:32.888037', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1082, 'f4bcebe9e4c749ddb5a7b03b25e7676a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 29, 'OK', '2026-06-29 19:57:33.308403', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1083, '6490625bac1f4425908b369711d3bd54', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 11, 'OK', '2026-06-29 19:57:33.515847', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1084, '6f15182f505845b9aea3ab9b1de334aa', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 19:57:33.810314', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1085, '8b19cccd08be49eaa6dd7437bafbf944', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'traceability', '/api/v1/greenhouses/traceability', 'GET', true, 1, 'OK', '2026-06-29 19:57:34.789261', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1086, '67975f66ce50456285d3de22890efcb4', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 5, 'OK', '2026-06-29 19:57:35.328221', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1087, '74b4461f9c4c499180bc17be34b55161', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 19:57:35.628004', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1088, '0fabe3e1885e43208e0b1c5ee8e42367', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 20:24:34.993302', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1089, '649199282785441a802f69aa3e23ffaf', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-29 20:24:34.999445', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1090, '5184b34c8e4e4032b574f29ba7aabfa3', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 20:29:27.392678', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1091, '55c46dea13a54b6b8d7172425ff97835', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 7, 'OK', '2026-06-29 20:29:27.397049', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1092, 'f72091e231f34f9bb4539d0a534ba3f3', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 20:34:28.691247', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1093, 'a5f7ecf7872945d2bc6928c7f70a6020', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 20:34:28.744341', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1094, 'e6f650e9299941f692d8ac72e790a086', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 3, 'OK', '2026-06-29 20:47:33.858865', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1095, '83176f0a477f48328a0873369ebd69a3', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 102, 'OK', '2026-06-29 23:08:49.968846', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1096, 'df86a495fad140a5bf4d36e2926958bb', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-29 23:08:50.047262', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1097, '3a1283fdfa804e04a630720741ac2865', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 23:08:50.066614', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1098, 'ad66f40f10f54479a7daf5370224f5f1', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 3, 'OK', '2026-06-29 23:08:50.079675', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1099, '3531b0d0d7b54722bfa96eb6b456b641', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 23:08:50.087785', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1100, '90efa468970140058c1e33d5d7f2955c', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 23:08:50.100020', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1101, 'b69977bfed0b42c2ae09aed73eba94a4', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 119, 'OK', '2026-06-29 23:08:50.221242', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1102, 'd88c5267e95b40e6af836f0cffb23009', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 23:08:50.227937', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1103, '00c3df17a0bd46558620d0adfc23f29f', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 2, 'OK', '2026-06-29 23:08:50.234565', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1104, '3b2a3fa532ee4b15be5c6416dd493a55', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 90, 'OK', '2026-06-29 23:28:11.735363', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1105, '3d726c052f064420beebaca1f40aad13', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-29 23:28:11.803546', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1106, '6925fa0101cb44d184de265d196c8a80', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 0, 'OK', '2026-06-29 23:28:11.823980', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1107, '83aab8860c224b829672a121a6267bb0', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 15, 'OK', '2026-06-29 23:28:11.832679', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1108, '74d00bf356a348fb86cc7afebba2d4b5', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 0, 'OK', '2026-06-29 23:28:11.842085', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1109, '0c87e43031e745adac0d3cc0089fbd50', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 23:37:03.719326', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1110, '2694d7cd9bf14a4b81b4a54be3d84eca', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 23:37:06.570917', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1111, 'de367a7e55364e5f9f4037f42e14d6a3', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 4, 'OK', '2026-06-29 23:37:06.601604', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1112, '3f0f30618b1d4971bfc78ba303364c60', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/3', 'GET', true, 2, 'OK', '2026-06-29 23:37:07.553050', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1113, '5ceeafe0a5054342b46a4a50767e464d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 0, 'OK', '2026-06-29 23:37:30.123682', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1114, 'def3ad53faf94f24a75ba78bd65b5a65', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 34, 'OK', '2026-06-29 23:37:36.104483', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1115, '0fc2cae05fa544e2b8df06a074bd034a', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 23:40:05.133315', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1116, '0207c8ba9dee429b8e1c95a9c3c3d4aa', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/3/greenhouses', 'GET', true, 11, 'OK', '2026-06-29 23:40:09.168451', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1117, 'fb331fe454c54638b4bd8d16c9044fa7', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 21, 'OK', '2026-06-29 23:40:09.521306', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1118, '47bf19d106ad43049f36965f118ddcbc', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 23:40:13.723942', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1119, '9d439499978b4fee909da9ef9e509415', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 5, 'OK', '2026-06-29 23:40:14.048107', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1120, '157af1074e8b41ada59f5be121d4a3cd', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 5, 'OK', '2026-06-29 23:41:11.151438', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1121, '6652c430f1ff4868b328bce2889f8cfd', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 23:41:25.072505', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1122, 'a5b1fa1218904d66be6d981517a5e344', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 11, 'OK', '2026-06-29 23:41:25.094993', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1123, '062d343e55f040e6bc341cefb1b99045', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 17, 'OK', '2026-06-29 23:41:25.525116', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1124, 'a6d8f7b31060496aa9e4ecf274c2a2c2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 23:41:32.167183', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1125, '21be56a2472c48808b8156e93b1f1476', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 23:41:32.167549', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1126, 'b40b86cbe87a421ba6f7aa9137c09a1e', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 0, 'OK', '2026-06-29 23:41:43.574195', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1127, '332480158dec409ab6fbc687881b93be', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-29 23:41:47.477156', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1128, 'b4e2004f0f164852baf9a7eca712db0d', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 23:42:00.016780', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1129, 'e9018100c9e64853b1b6e82badff90e6', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 57, 'OK', '2026-06-29 23:42:01.971442', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1130, 'b81655a6d98943c38dd61dd3df4ce349', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 0, 'OK', '2026-06-29 23:42:48.084354', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1131, 'd0c581ecaefa4518bc757ac433a5b04e', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-29 23:42:51.563607', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1132, '1fa420044c2943afb9747915af8288b4', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 23:42:51.832070', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1133, 'aee2b6416fb44bcfae9f8af34231fe4a', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 24, 'OK', '2026-06-29 23:42:51.979862', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1134, 'b5d873d6fabb4a1e835567145f305fef', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 23:42:56.987938', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1135, 'dbf17746ba814120a3b2059321d55bb2', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 18, 'OK', '2026-06-29 23:42:57.331141', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1136, 'aa2a84903cdf4f7298db777fbf7f3b24', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 0, 'OK', '2026-06-29 23:43:00.277278', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1137, '6092a3c8f11a4183a7325eb461bdc6e7', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-29 23:43:00.933118', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1138, '4a388d22dbd148f28caa5fe506b8e6bd', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/3/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 23:43:05.941320', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1139, 'd73c11b7ccd54219be3c258258ead770', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 8, 'OK', '2026-06-29 23:43:06.275386', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1140, '61a76e199c7342a598a1ac370ebcac39', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 23:43:07.220215', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1141, '5eb808cc12a545799911831b1155b5f8', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 5, 'OK', '2026-06-29 23:43:07.544657', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1142, 'ca06da3861bd4547be0f3a89ab7fe370', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 23:44:42.060307', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1143, '53295666eaed4e90a042797c784c280f', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 1, 'OK', '2026-06-29 23:44:43.681750', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1144, 'cc920d7b181445798891dc48ba1e2809', 'admin', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 23:44:46.623596', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1145, '891f9b3d063e4be582d1128763620e68', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 10, 'OK', '2026-06-29 23:44:46.633520', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1146, '193af8559c0c41398a8091d6a3f62e9c', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 23:47:49.858140', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1147, '004f803e5224460da1f960e67d243a97', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 2, 'OK', '2026-06-29 23:47:52.164391', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1148, '716c45b94fb04f98833af480a2fd187c', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 23:47:52.897417', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1149, '93a8bbe418ee45e18a97f9b6383d57b6', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 1, 'OK', '2026-06-29 23:47:53.161062', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1150, '2c48e8f6f1904944b86c41e8f691755f', 'admin', '0:0:0:0:0:0:0:1', 'UserController', 'feedbacks', '/api/v1/users/feedback', 'GET', true, 0, 'OK', '2026-06-29 23:47:58.336321', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1151, '5627e8bbda2344ef84e2ff47f4ca3da1', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 129, 'OK', '2026-06-29 23:48:54.907294', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1152, '6ffd33aebf144e5e9712dcab07c31fda', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 11, 'OK', '2026-06-29 23:48:55.048853', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1153, '0407159141204eb18aec0739eba53616', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 5, 'OK', '2026-06-29 23:48:58.583366', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1154, 'a72eedaa5d994741845fadadfd81af2e', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 0, 'OK', '2026-06-29 23:49:00.513399', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1155, '6448d2425d984c9087544d841822c3a5', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 43, 'OK', '2026-06-29 23:49:03.433857', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1156, '221683d26f054c7f8fb6394bbc03e901', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 8, 'OK', '2026-06-29 23:51:06.326303', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1157, '4c69d0c1944b469eb4d77e8cdb6842f0', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 6, 'OK', '2026-06-29 23:51:08.522805', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1158, 'f470e507cbc3423a8c7f7d51f8907d48', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 0, 'OK', '2026-06-29 23:51:10.072932', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1159, 'd9b0c585e695402882faffe8b904d9bf', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-29 23:51:16.515071', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1160, 'ffc78333c13a46d9bde57ea9667895cb', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-29 23:51:16.842287', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1161, 'eee0e94dce544a5b8c9c1b77d5ae85be', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-29 23:51:19.547968', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1162, '480679f14c384c7c8acb3e5615e0af12', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-29 23:51:20.833305', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1165, '4405d1e969534956b8e8669aae56769c', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 23:52:15.137241', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1172, '4b20d78535c945208e1452af3ced168c', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 2, 'OK', '2026-06-29 23:53:16.815137', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1175, '71490c1e2ffe43e6b232a2e6fcd77e33', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 5, 'OK', '2026-06-29 23:53:51.375843', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1182, '65a65679cb754f068691df529611e5a5', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 0, 'OK', '2026-06-29 23:55:38.016284', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1185, '634af6e6bfed4a3bacffabd6c2786c78', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 1, 'OK', '2026-06-29 23:55:41.213559', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1163, 'ef151001f43c41298ebb531a0695096e', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-29 23:52:08.536541', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1164, '29801110eaaf4b2ea6f21ec38daaaf82', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 53, 'OK', '2026-06-29 23:52:08.914128', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1166, '573bc45aef55479bac0a3ebf8c78c942', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 10, 'OK', '2026-06-29 23:52:15.480982', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1167, '29282aad5e1b4d00aada304f9644cfae', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/3', 'GET', true, 0, 'OK', '2026-06-29 23:52:16.133770', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1168, '9e298e86315e4a11a186ae86b9cf0300', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 0, 'OK', '2026-06-29 23:53:06.842649', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1169, '79263638d5cd4d4aa23057cc03634507', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/3', 'GET', true, 3, 'OK', '2026-06-29 23:53:07.543979', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1170, '3283efb820f64e9f97972835a405c2d9', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 2, 'OK', '2026-06-29 23:53:12.567729', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1171, 'f65ece09eff54d09ae45bb51e254e27b', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 0, 'OK', '2026-06-29 23:53:14.088193', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1173, '6ea316266d434ebd8bdaf94885ce1abe', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 10, 'OK', '2026-06-29 23:53:18.176214', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1174, '95c8e15435b14a98acce6dcddac61427', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 1, 'OK', '2026-06-29 23:53:45.330952', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1176, 'd2e96f9f94fb4f89b8928e88465a4ad3', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 23:54:34.844891', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1177, '7d060bc6ee564939b91318815d827305', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-29 23:54:35.104768', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1178, '36729ca61a2448a59f7d488af0227bda', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-29 23:54:40.168648', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1179, '97c9bfb955594c8bbcda9e7f6d60e517', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-29 23:54:41.653697', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1180, '0ab9fb1cab5044e1a03acc347cd1a2ed', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-29 23:54:42.438081', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1181, '64e641bd57bd4dd997562384179c4980', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 3, 'OK', '2026-06-29 23:54:42.770528', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1183, '9f4af49f851546f1beee1a140a5a447e', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 0, 'OK', '2026-06-29 23:55:39.184141', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1184, '3ce2ae50809a41d68adff6827a459820', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 2, 'OK', '2026-06-29 23:55:39.676354', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1186, '4b2d9dbfff304f84b476461da6fc6ec2', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 0, 'OK', '2026-06-29 23:55:42.462587', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1187, 'd18e7fbd9d7f40adb612df31d03df47f', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 0, 'OK', '2026-06-29 23:55:43.150832', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1188, 'c111a187451341a091458719d84d1124', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-29 23:56:47.699868', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1189, 'a0975f342e844c688efeb743e0e6e2fb', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 10, 'OK', '2026-06-29 23:56:47.971311', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1190, '7a45c6e6462a48ca942951a824c57b8f', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-29 23:56:49.721102', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1191, '44cb22e9c56b4d7eb40dd0b7427e4ac2', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 6, 'OK', '2026-06-29 23:56:50.044956', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1192, '8adcd93a1e94461ea9a04298b9164c8e', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 3, 'OK', '2026-06-29 23:57:56.501365', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1193, 'd6cec02e146e438ab89656d4a9996a72', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 4, 'OK', '2026-06-30 00:30:13.045974', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1194, '8116f786f0534330b6089fbe77a23a49', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 95, 'OK', '2026-06-30 00:51:52.900664', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1195, 'd12f5d6bc9e34358a4d036f44f3ea46b', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 9, 'OK', '2026-06-30 00:51:52.976517', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1196, 'f8b75b57f0284b5e8cc49a561771d853', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 15, 'OK', '2026-06-30 00:51:53.003153', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1197, '28e96e1af5c44b468bc9b37c1bf19c16', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-30 00:51:53.023489', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1198, 'c3090af9e8ec49e687eca0e7baeafbe5', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'createDevice', '/api/v1/greenhouses/devices', 'POST', false, 1, '管理员只能查看设备，不能新增、修改或删除设备', '2026-06-30 00:51:53.073393', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1199, 'b2ab5b3a40934d85ab1e6f5ca23d6fb1', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 123, 'OK', '2026-06-30 00:51:53.219387', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1200, '64ffd1fd02e54a79b0791bdcf1a92d64', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 00:51:53.227906', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1201, '12337b5b743d4355a71f9786beb691dd', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 32, 'OK', '2026-06-30 00:51:53.253012', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1202, 'e5e33aba52f14616b6869957c3860881', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 0, 'OK', '2026-06-30 00:51:53.273131', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1203, '1d9ed1a1108d4a7697140c4f5e99d0cf', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 103, 'OK', '2026-06-30 00:52:26.321242', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1204, 'd255877ac9c14e95ad983ede488a5a7e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 83, 'OK', '2026-06-30 00:52:26.442942', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1205, '5f63b386b6dc4e8d8f4dfe1ca2e65f3f', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 00:52:26.448475', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1206, '7d7f93ca67f749d1aa9b2d1991865956', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'createDevice', '/api/v1/greenhouses/devices', 'POST', true, 2, 'OK', '2026-06-30 00:52:26.474322', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1207, '92806c35ba0d442c839c8f77b1763444', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-30 00:52:26.480114', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1208, '407e678afebd42bf91667c74879dde12', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 4, 'OK', '2026-06-30 00:52:26.488187', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1209, '1ecd5d829d08419e9e422ca4e48970fe', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'handleAlert', '/api/v1/greenhouses/alerts/5/handle', 'POST', true, 0, 'OK', '2026-06-30 00:52:26.520640', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1210, 'b2b57a8767c54d6c8875ac4fcb7f8337', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 0, 'OK', '2026-06-30 00:52:26.525107', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1211, '8a427fcd66cb4013a78a5dedd2a06269', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 108, 'OK', '2026-06-30 00:53:29.147735', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1212, 'a1a6682dfd1147e0a305af3ddfe1d67b', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 00:53:29.204658', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1213, 'bffae15eb64c43c69b3713fe442a077a', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-30 00:53:29.221490', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1214, '4d01cb690c5740d797bc2bdd4748b55a', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 2, 'OK', '2026-06-30 00:53:29.250092', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1215, 'a9736c8bde964eb6bdc4e9ca83194f91', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-30 00:53:29.258916', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1216, 'f6708688e5054ab5bfdd8a1308c836fb', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-30 00:53:29.265664', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1217, '0bf86c61336542d2a6ed20bcce2afa2a', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 111, 'OK', '2026-06-30 01:03:26.511310', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1218, 'cc1dd8ba21104d749ff65148bf70c1cf', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 132, 'OK', '2026-06-30 01:03:26.714742', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1219, '9e50fdda6e0c4a97adb264d32698526e', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 0, 'OK', '2026-06-30 01:03:26.730130', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1220, 'eacd2aa3833445478a374af053ecfba6', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 01:03:26.766080', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1221, 'c2576dec55d5405d8e619ffa2a03b154', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 0, 'OK', '2026-06-30 01:03:26.787512', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1222, 'ef5bf6e564154081bbe3e6eea097d711', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 01:03:26.800983', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1223, '63ffb3f1b83c422b8d376e7175558ef3', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 20, 'OK', '2026-06-30 01:03:26.839968', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1224, 'bc995a745cfa42a4b3670416ba671b7c', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'createDevice', '/api/v1/greenhouses/devices', 'POST', false, 15, '管理员只能查看设备，不能新增、修改或删除设备', '2026-06-30 01:03:26.936045', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1225, 'e0b9dc8bd58244afbd379ffb0a1800dd', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'createDevice', '/api/v1/greenhouses/devices', 'POST', true, 13, 'OK', '2026-06-30 01:03:26.965030', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1226, '3434292cc9ab463e806547257e6467a5', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-30 01:03:26.975247', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1227, '9e4b58bbb8e44058a7d8bc4024068a6a', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 171, 'OK', '2026-06-30 01:03:44.514251', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1228, '8df84ca690754abe83974917bded9985', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-30 01:03:44.570529', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1229, '25c515389b1a487182612b237b356014', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 4, 'OK', '2026-06-30 01:03:44.587521', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1230, '13ca9b4ae6b94da69f8cf5defb53be34', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 114, 'OK', '2026-06-30 01:06:50.313427', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1231, '12211ca412534314baa6c84cef796179', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 4, 'OK', '2026-06-30 01:06:50.430602', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1232, 'ccb6a9c6215748dab2c7886f8fb05dd5', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 2, 'OK', '2026-06-30 01:06:52.190901', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1233, 'e938d477cdb14c8baa4d1b63edc17fb0', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 101, 'OK', '2026-06-30 01:07:18.458439', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1234, 'e0f65d24ff1f480a925d06a727f30d3b', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 7, 'OK', '2026-06-30 01:07:18.536407', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1235, '8ec3d35529e54fa88021fdc382c5b2a1', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 6, 'OK', '2026-06-30 01:07:21.231594', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1236, 'ad891116d901488aa3d0e59f07285e12', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 8, 'OK', '2026-06-30 01:07:21.619725', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1237, '715521d3712e491bb79642fc1e2d5330', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/3', 'GET', true, 2, 'OK', '2026-06-30 01:07:25.059978', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1238, '06f91c5b4960465f96080706c712e371', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/4', 'GET', true, 3, 'OK', '2026-06-30 01:07:28.475512', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1239, 'e18671c4c5574260a1aaeaa88fe34f31', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/5', 'GET', true, 4, 'OK', '2026-06-30 01:07:30.133749', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1240, 'b25f90aa50484e799f78d4a96f8d03a9', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/3', 'GET', true, 0, 'OK', '2026-06-30 01:07:34.136826', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1241, '862514a7f1cb427d802fb2744574c647', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-30 01:07:37.830174', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1242, '3de14df3692e4cb8b4e2fff32a97de0a', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/1/greenhouses', 'GET', true, 3, 'OK', '2026-06-30 01:07:41.360617', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1243, '3ed109853af64dba963bc62a3af81b27', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 12, 'OK', '2026-06-30 01:07:44.378218', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1244, '71c0d9d5edb54d46b3ffb9dfdb37ff30', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 14, 'OK', '2026-06-30 01:07:47.027190', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1245, '76e06381ad6547a0bb9f9b34099d3eb9', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-30 01:07:58.571415', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1246, 'a758e5ec75054474b089f2e7ccde16c7', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/1/greenhouses', 'GET', true, 3, 'OK', '2026-06-30 01:08:02.583572', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1247, 'fb162ecdef2942a0870a97ea55a58483', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-30 01:08:02.772943', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1248, 'a55e7c664d2a422ea50e5d2460df6d86', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-30 01:08:04.686612', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1249, '44468d29233a4417abd031adefc5437c', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 6, 'OK', '2026-06-30 01:08:06.207775', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1250, '9a55c968e4e5444a866506661dfa1c60', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 1, 'OK', '2026-06-30 01:08:11.349997', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1251, '5935d1611dd844e393d9f4f157c6436b', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 10, 'OK', '2026-06-30 01:08:13.382158', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1252, '99b9f3a8e1a64e799f4e49a7933cebb5', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 01:08:42.254248', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1253, '8fe72cbb0f6e46dc88f0239ba405016a', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'alertDetails', '/api/v1/greenhouses/alerts/detail', 'GET', true, 13, 'OK', '2026-06-30 01:08:42.614067', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1254, '76370ff33b1c4cbc805ddfe0e5dd7364', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-30 01:08:53.970077', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1255, '4e13943fe3914eb1b433ab68899e1303', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 0, 'OK', '2026-06-30 01:08:54.302388', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1256, '95b6f69d3e3649a7aa3e5c221e89f06b', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/3', 'GET', true, 6, 'OK', '2026-06-30 01:08:57.235910', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1257, '42b2047108e240558d700faf9be7d87a', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/2/profile', 'GET', true, 2, 'OK', '2026-06-30 01:09:00.953896', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1258, '8295872b4bf643dab1f2203f5c41d489', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 4, 'OK', '2026-06-30 01:09:08.995874', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1259, '8c779f147edd40bf861f39328caa7575', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-30 01:09:09.297085', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1260, '614d6ea01cbf42d0a22b0fd8d0a2b626', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'createUser', '/api/v1/users', 'POST', true, 187, 'OK', '2026-06-30 01:10:22.935715', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1261, '2a9186c15be1409b8345c728f3adfe8e', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 1, 'OK', '2026-06-30 01:10:22.955092', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1262, 'df00037e5888418dbabb36c7d1d905c0', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 1, 'OK', '2026-06-30 01:10:23.259422', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1263, 'de0c15071ed3497a9c91b62c15afc7fe', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'updateUser', '/api/v1/users/5', 'PUT', true, 10, 'OK', '2026-06-30 01:10:37.712709', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1264, '0285a155aa0a448b9f717edcc555ada2', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 52, 'OK', '2026-06-30 01:10:38.052083', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1265, '256fffba57ed4656ac3e4210b745423f', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-30 01:10:38.060848', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1266, '27408c512e044670870b9e89fc0ada8d', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'updateUser', '/api/v1/users/2', 'PUT', true, 5, 'OK', '2026-06-30 01:10:44.809934', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1267, 'a8887f0388364d8fb9f0518955e4d808', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-30 01:10:45.132531', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1268, 'f255a2c755f04e9299bbbef25577ce73', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-30 01:10:45.133973', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1269, '75384ac988e6406390aeb1b724c71479', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 4, 'OK', '2026-06-30 01:10:51.462442', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1270, '9037871c3e9344e09a221c8e014d0224', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 2, 'OK', '2026-06-30 01:10:51.827912', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1271, 'd2bc4111bd9a4c78afc12612dd958419', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 144, 'OK', '2026-06-30 01:11:05.722012', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1272, '80bba10818844e4fb799faa743d9d059', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 12, 'OK', '2026-06-30 01:11:06.101797', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1273, '53bb068cc00a4f37ae3c56baf19fdbcf', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-30 01:11:10.975314', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1274, 'a5d6e916ab844af980a947aa740a371c', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 4, 'OK', '2026-06-30 01:11:12.617651', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1275, '6b2fec9a0e8e46c5ab65af4c13c7ff51', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'profile', '/api/v1/users/1/profile', 'GET', true, 0, 'OK', '2026-06-30 01:11:13.481298', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1276, '1bc087ce48c9424c827cf76eab1a1a30', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 2, 'OK', '2026-06-30 01:11:15.134145', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1277, 'd23823e60a51422c9f6f4190e321537c', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 2, 'OK', '2026-06-30 01:11:15.385165', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1278, '5115b943350b48ebb69614f59312be81', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 3, 'OK', '2026-06-30 01:11:17.470903', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1279, 'ff8113a7004d4e42b95c3ec06bdf9b82', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 2, 'OK', '2026-06-30 01:11:28.235538', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1280, '297491b67ee048f291a36a1bec39f23e', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 5, 'OK', '2026-06-30 01:11:28.500824', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1281, 'dcf5598992394c44936afd3e6cbabcc8', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-30 01:11:30.711634', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1282, 'da77660fe96a4131aac0c935ec910090', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 32, 'OK', '2026-06-30 01:11:31.102824', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1283, 'cea3c616d16746fab6aa3203c4a66382', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 13, 'OK', '2026-06-30 01:11:48.237809', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1284, '189c1271cd404ea6a5e6f047479584fb', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 01:11:49.854855', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1285, 'c3f851e69bd7423da4659e28d48e4b51', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 17, 'OK', '2026-06-30 01:11:50.118478', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1286, '8782964a5a0f48aa84ee0acb0066d59e', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 129, 'OK', '2026-06-30 01:15:00.246300', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1287, 'a9be512c09944783beeaf526c7a5dfcc', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 3, 'OK', '2026-06-30 01:15:00.316595', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1288, '64f26236896e4caaa1dfc32d41e65ecb', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/1/greenhouses', 'GET', true, 1, 'OK', '2026-06-30 01:15:00.345550', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1289, '34494f62c52147c7a0999590fc10fbe0', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 3, 'OK', '2026-06-30 01:15:00.358302', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1290, '567315b044a7419ba81b3d412b289f04', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 163, 'OK', '2026-06-30 01:15:27.391716', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1291, 'bd38480fc4454a2e96f625b59b636c8a', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'users', '/api/v1/users', 'GET', true, 2, 'OK', '2026-06-30 01:15:27.444053', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1292, '6ec5baffd14547b1b24ed98345a2da03', 'admin1', '0:0:0:0:0:0:0:1', 'UserController', 'farmerGreenhouses', '/api/v1/users/1/greenhouses', 'GET', true, 1, 'OK', '2026-06-30 01:15:27.462923', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1293, '8091e9239e8b4902b5a6bb2f372cac48', 'admin1', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-30 01:15:27.474381', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1294, '916d0e8729924fa0b49017eca2d0ad32', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-30 01:20:23.623957', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1295, 'ac50c011643745c183b0a727e6ccd118', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 19, 'OK', '2026-06-30 01:20:23.697854', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1296, 'e16bc678b081437b84ed2e9574501d43', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 01:21:27.925273', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1297, '34be503563b04b168000441d6c7f7fd8', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 6, 'OK', '2026-06-30 01:21:29.286151', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1298, 'd6a5d236f16b4fe59e43c46675a84bc7', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 36, 'OK', '2026-06-30 01:29:41.581879', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1299, 'df8463699b9241d0b9244a718f204eb1', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'analytics', '/api/v1/greenhouses/analytics', 'GET', true, 16, 'OK', '2026-06-30 01:29:42.100406', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1300, '853eeaf3b0424fb3bd5e5e4b4a99c8fb', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 4, 'OK', '2026-06-30 01:30:18.055146', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1301, '5c255f27c3d444e480f526ab0f02343a', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batches', '/api/v1/greenhouses/batches', 'GET', true, 7, 'OK', '2026-06-30 01:30:18.106158', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1302, 'c9b0be38178b41dba6a4aa4cbd6cd538', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'batchDetail', '/api/v1/greenhouses/batches/3', 'GET', true, 0, 'OK', '2026-06-30 01:30:19.422787', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1303, '2f7afe900a17408a98f4b74080956b17', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 2, 'OK', '2026-06-30 01:30:23.163277', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1304, 'a60732a8af7542948cf5593e0cf6ab7a', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 2, 'OK', '2026-06-30 01:30:23.502371', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1305, '43b4fc71968c4aedbf5235f4ab8b7c82', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 2, 'OK', '2026-06-30 01:30:26.695989', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1306, '61e61407d0c74fed85c5035a9cb7e052', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 4, 'OK', '2026-06-30 01:30:36.603770', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1307, 'a8d0a966fa3445ecae06801a49163791', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackConversations', '/api/v1/users/feedback/conversations', 'GET', true, 3, 'OK', '2026-06-30 01:55:13.633553', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1308, '1bb2538a5203406598eebbcc740230c0', 'farmer001', '0:0:0:0:0:0:0:1', 'UserController', 'feedbackMessages', '/api/v1/users/feedback/conversations/1/messages', 'GET', true, 5, 'OK', '2026-06-30 01:55:14.543879', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1309, '9c9219a5407846f784bb15a5b90a1526', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 14, 'OK', '2026-06-30 01:55:16.955821', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1310, 'ae05d3c5400d4b08aed5fa000230a063', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 3, 'OK', '2026-06-30 01:55:21.201598', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1311, '270ef7d5378d448fb8f18ca12319a111', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-30 01:55:21.231961', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1312, '9222a2d6764b4f1da047ac5f1e00a50f', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'overview', '/api/v1/greenhouses/overview', 'GET', true, 10, 'OK', '2026-06-30 01:55:22.649758', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1313, 'adb62384398d4a87802cd9e0113308cc', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'listGreenhouses', '/api/v1/greenhouses', 'GET', true, 0, 'OK', '2026-06-30 01:55:33.629296', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1314, 'ec6dc760215742d88abeae6b16f2ad15', 'farmer001', '0:0:0:0:0:0:0:1', 'GreenhouseController', 'devices', '/api/v1/greenhouses/devices', 'GET', true, 0, 'OK', '2026-06-30 01:55:33.916959', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1315, '9e5dfa76997a45f6b06991d1e56632e8', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 78, 'OK', '2026-06-30 09:15:02.008686', NULL, 'LOW', NULL);
INSERT INTO public.operation_log (id, trace_id, username, client_ip, module_name, action_name, request_uri, http_method, success, elapsed_ms, message, created_at, user_id, risk_level, request_digest) VALUES (1316, '1629a1deb1e644b5b619a1c7537f9e31', NULL, '0:0:0:0:0:0:0:1', 'AuthController', 'login', '/api/v1/auth/login', 'POST', true, 74, 'OK', '2026-06-30 09:15:37.124014', NULL, 'LOW', NULL);


--
-- Data for Name: production_batch; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.production_batch (id, batch_no, greenhouse_id, batch_name, crop_name, status, started_at, expected_harvest_at, actual_harvest_at, summary, deleted, created_at, updated_at, deleted_at) VALUES (3, 'ML-202606-A01', 1, 'A01 春季羊肚菌示范批次', '羊肚菌', 'RUNNING', '2026-06-01 00:00:00', '2026-07-11 00:00:00', NULL, '菌丝恢复稳定，进入出菇期环境精细调控。', false, '2026-06-29 23:07:27.095499', '2026-06-29 23:07:27.095499', NULL);
INSERT INTO public.production_batch (id, batch_no, greenhouse_id, batch_name, crop_name, status, started_at, expected_harvest_at, actual_harvest_at, summary, deleted, created_at, updated_at, deleted_at) VALUES (4, 'ML-202606-A02', 6, 'A02 菌丝恢复批次', '羊肚菌', 'RUNNING', '2026-06-14 00:00:00', '2026-07-22 00:00:00', NULL, '菌丝恢复期湿度偏高，重点关注通风和水分控制。', false, '2026-06-30 00:51:11.869320', '2026-06-30 00:51:11.869320', NULL);
INSERT INTO public.production_batch (id, batch_no, greenhouse_id, batch_name, crop_name, status, started_at, expected_harvest_at, actual_harvest_at, summary, deleted, created_at, updated_at, deleted_at) VALUES (5, 'ML-202606-A03', 7, 'A03 催菇试验批次', '羊肚菌', 'RUNNING', '2026-06-22 00:00:00', '2026-07-30 00:00:00', NULL, '催菇参数试验中，重点观察温差和光照变化。', false, '2026-06-30 00:51:11.871184', '2026-06-30 00:51:11.871184', NULL);


--
-- Data for Name: production_batch_event; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.production_batch_event (id, batch_id, event_code, event_title, event_status, operator, event_time, description, block_hash, previous_hash, sort_order, deleted, created_at, updated_at, deleted_at) VALUES (1, 3, 'SUBSTRATE_IN', '基质入棚', 'DONE', '张工', '2026-06-01 23:07:27.099392', '完成培养基入棚、消毒记录和批次建档。', 'BATCH-A01-001', NULL, 10, false, '2026-06-29 23:07:27.099392', '2026-06-29 23:07:27.099392', NULL);
INSERT INTO public.production_batch_event (id, batch_id, event_code, event_title, event_status, operator, event_time, description, block_hash, previous_hash, sort_order, deleted, created_at, updated_at, deleted_at) VALUES (2, 3, 'MYCELIUM_RECOVERY', '菌丝恢复', 'DONE', '李工', '2026-06-15 23:07:27.103106', '湿度目标上调至 86%，菌丝恢复状态良好。', 'BATCH-A01-002', 'BATCH-A01-001', 20, false, '2026-06-29 23:07:27.103106', '2026-06-29 23:07:27.103106', NULL);
INSERT INTO public.production_batch_event (id, batch_id, event_code, event_title, event_status, operator, event_time, description, block_hash, previous_hash, sort_order, deleted, created_at, updated_at, deleted_at) VALUES (3, 3, 'FRUITING_CONTROL', '出菇期调控', 'RUNNING', '管理员', '2026-06-27 23:07:27.120321', '温度、湿度、CO2 浓度进入连续监测与告警闭环。', 'BATCH-A01-003', 'BATCH-A01-002', 30, false, '2026-06-29 23:07:27.120321', '2026-06-29 23:07:27.120321', NULL);


--
-- Data for Name: sys_dict_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (1, 'GREENHOUSE_STATUS', 'ONLINE', '在线', 'ONLINE', 'success', true, 1, NULL, false, '2026-06-29 13:44:45.704179', '2026-06-29 13:44:45.704179', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (2, 'GREENHOUSE_STATUS', 'WARNING', '预警', 'WARNING', 'warning', true, 2, NULL, false, '2026-06-29 13:44:45.709125', '2026-06-29 13:44:45.709125', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (3, 'GREENHOUSE_STATUS', 'OFFLINE', '离线', 'OFFLINE', 'info', true, 3, NULL, false, '2026-06-29 13:44:45.803360', '2026-06-29 13:44:45.803360', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (4, 'DEVICE_STATUS', 'RUNNING', '运行中', 'RUNNING', 'success', true, 1, NULL, false, '2026-06-29 13:44:45.809238', '2026-06-29 13:44:45.809238', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (5, 'DEVICE_STATUS', 'STOPPED', '已停止', 'STOPPED', 'info', true, 2, NULL, false, '2026-06-29 13:44:45.815224', '2026-06-29 13:44:45.815224', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (6, 'DEVICE_STATUS', 'MAINTENANCE', '维护中', 'MAINTENANCE', 'warning', true, 3, NULL, false, '2026-06-29 13:44:45.820536', '2026-06-29 13:44:45.820536', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (7, 'ALERT_LEVEL', 'INFO', '提示', 'INFO', 'info', true, 1, NULL, false, '2026-06-29 13:44:45.825774', '2026-06-29 13:44:45.825774', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (8, 'ALERT_LEVEL', 'WARNING', '警告', 'WARNING', 'warning', true, 2, NULL, false, '2026-06-29 13:44:45.830411', '2026-06-29 13:44:45.830411', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (9, 'ALERT_LEVEL', 'CRITICAL', '严重', 'CRITICAL', 'danger', true, 3, NULL, false, '2026-06-29 13:44:45.835798', '2026-06-29 13:44:45.835798', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (10, 'ALERT_STATUS', 'OPEN', '待处理', 'OPEN', 'danger', true, 1, NULL, false, '2026-06-29 13:44:45.841213', '2026-06-29 13:44:45.841213', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (11, 'ALERT_STATUS', 'ACKNOWLEDGED', '已确认', 'ACKNOWLEDGED', 'warning', true, 2, NULL, false, '2026-06-29 13:44:45.846528', '2026-06-29 13:44:45.846528', NULL);
INSERT INTO public.sys_dict_item (id, type_code, item_code, item_name, item_value, tag_type, enabled, sort_order, remark, deleted, created_at, updated_at, deleted_at) VALUES (12, 'ALERT_STATUS', 'RESOLVED', '已解决', 'RESOLVED', 'success', true, 3, NULL, false, '2026-06-29 13:44:45.851480', '2026-06-29 13:44:45.851480', NULL);


--
-- Data for Name: sys_dict_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_dict_type (id, type_code, type_name, description, enabled, sort_order, deleted, created_at, updated_at, deleted_at) VALUES (1, 'GREENHOUSE_STATUS', '大棚状态', '大棚运行状态字典', true, 10, false, '2026-06-29 13:44:45.648357', '2026-06-29 13:44:45.648357', NULL);
INSERT INTO public.sys_dict_type (id, type_code, type_name, description, enabled, sort_order, deleted, created_at, updated_at, deleted_at) VALUES (2, 'DEVICE_STATUS', '设备状态', '设备运行状态字典', true, 20, false, '2026-06-29 13:44:45.654875', '2026-06-29 13:44:45.654875', NULL);
INSERT INTO public.sys_dict_type (id, type_code, type_name, description, enabled, sort_order, deleted, created_at, updated_at, deleted_at) VALUES (3, 'ALERT_LEVEL', '告警级别', '告警严重程度字典', true, 30, false, '2026-06-29 13:44:45.697798', '2026-06-29 13:44:45.697798', NULL);
INSERT INTO public.sys_dict_type (id, type_code, type_name, description, enabled, sort_order, deleted, created_at, updated_at, deleted_at) VALUES (4, 'ALERT_STATUS', '告警状态', '告警闭环处理状态字典', true, 40, false, '2026-06-29 13:44:45.700602', '2026-06-29 13:44:45.700602', NULL);


--
-- Data for Name: sys_permission; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: sys_role; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: telemetry_snapshot; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (1, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-25 02:02:29.665907');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (2, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-25 13:54:37.111154');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (3, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-25 14:27:57.452076');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (4, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-25 14:33:48.870499');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (37, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-25 17:23:45.829916');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (38, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-25 21:16:48.261433');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (40, 3, 20.00, 80.00, 3600, 760, 60.00, '2026-06-26 21:09:18.143968');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (47, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 01:53:03.334331');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (48, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 02:23:35.286422');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (49, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 02:58:32.750163');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (50, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 03:00:43.876973');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (51, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 03:10:24.044627');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (52, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 03:16:55.076676');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (53, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 03:20:05.357763');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (54, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 12:36:18.241442');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (55, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 13:04:04.247502');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (56, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 13:07:29.039290');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (57, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 13:44:46.458782');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (58, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 15:16:25.336327');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (59, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 16:16:44.323423');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (60, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 16:29:51.634041');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (61, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 16:31:14.000842');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (62, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 18:52:53.838515');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (63, 5, 20.00, 80.00, 3600, 760, 60.00, '2026-06-29 19:07:36.407159');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (64, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 19:23:23.191911');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (65, 1, 21.80, 84.60, 4280, 790, 62.50, '2026-06-29 21:02:07.065704');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (66, 6, 18.90, 91.20, 3100, 1180, 67.40, '2026-06-30 00:51:11.834231');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (67, 7, 22.40, 78.60, 4450, 690, 59.80, '2026-06-30 00:51:11.844698');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (68, 1, 21.50, 84.00, 4200, 760, 61.50, '2026-06-30 08:14:07.597093');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (69, 1, 21.10, 85.20, 4100, 790, 62.00, '2026-06-30 07:14:07.597093');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (70, 1, 20.80, 86.40, 3950, 830, 62.70, '2026-06-30 06:14:07.597093');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (71, 1, 20.40, 87.10, 3800, 870, 63.20, '2026-06-30 05:14:07.597093');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (72, 1, 20.00, 86.80, 3600, 910, 63.50, '2026-06-30 04:14:07.597093');
INSERT INTO public.telemetry_snapshot (id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at) VALUES (73, 1, 19.80, 85.90, 3400, 880, 63.10, '2026-06-30 03:14:07.597093');


--
-- Data for Name: traceability_record; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.traceability_record (id, greenhouse_id, batch_no, operation, operator, operation_date, note, deleted, created_by, updated_by, deleted_by, created_at, updated_at, deleted_at) VALUES (1, 1, 'ML-202606-A01', '基质入棚', '张工', '2026-05-28 00:00:00', '完成批次建档并绑定溯源码', false, NULL, NULL, NULL, '2026-06-29 13:44:45.390010', '2026-06-29 13:44:45.391335', NULL);


--
-- Data for Name: verification_code; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.verification_code (id, receiver, scene, code, used, expires_at, created_at, client_ip, delivery_status, delivery_message, sent_at) VALUES (5, 'codex-test@example.com', 'REGISTER', '374353', false, '2026-06-29 15:23:20.454758', '2026-06-29 15:18:20.451270', '0:0:0:0:0:0:0:1', 'SENT', '邮箱服务未配置，已生成开发验证码', '2026-06-29 15:18:20.451270');
INSERT INTO public.verification_code (id, receiver, scene, code, used, expires_at, created_at, client_ip, delivery_status, delivery_message, sent_at) VALUES (6, 'codex-rate-162100@example.com', 'REGISTER', '739540', false, '2026-06-29 16:26:01.099440', '2026-06-29 16:21:01.093586', '0:0:0:0:0:0:0:1', 'SENT', '邮箱服务未配置，已生成开发验证码', '2026-06-29 16:21:01.093586');
INSERT INTO public.verification_code (id, receiver, scene, code, used, expires_at, created_at, client_ip, delivery_status, delivery_message, sent_at) VALUES (7, 'codex-block-163352@example.com', 'REGISTER', '263565', false, '2026-06-29 16:38:52.728168', '2026-06-29 16:33:52.729016', '0:0:0:0:0:0:0:1', 'SENT', '邮箱服务未配置，已生成开发验证码', '2026-06-29 16:33:52.732501');
INSERT INTO public.verification_code (id, receiver, scene, code, used, expires_at, created_at, client_ip, delivery_status, delivery_message, sent_at) VALUES (8, 'CHMgGa@163.com', 'RESET_PASSWORD', '789316', false, '2026-06-29 19:10:47.330439', '2026-06-29 19:05:47.331438', '0:0:0:0:0:0:0:1', 'SENT', '邮箱服务未配置，已生成开发验证码', '2026-06-29 19:05:47.334347');
INSERT INTO public.verification_code (id, receiver, scene, code, used, expires_at, created_at, client_ip, delivery_status, delivery_message, sent_at) VALUES (9, 'wyvern06@163.com', 'RESET_PASSWORD', '264726', false, '2026-06-29 19:24:46.807695', '2026-06-29 19:19:46.808123', '0:0:0:0:0:0:0:1', 'SENT', '邮箱服务未配置，已生成开发验证码', '2026-06-29 19:19:46.810031');
INSERT INTO public.verification_code (id, receiver, scene, code, used, expires_at, created_at, client_ip, delivery_status, delivery_message, sent_at) VALUES (10, 'wyvern06@163.com', 'RESET_PASSWORD', '723741', false, '2026-06-29 19:29:04.416211', '2026-06-29 19:24:04.417073', '0:0:0:0:0:0:0:1', 'SENT', '验证码已发送至邮箱', '2026-06-29 19:24:11.211265');


--
-- Data for Name: verification_send_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (1, 'codex-test@example.com', 'REGISTER', 'EMAIL', '0:0:0:0:0:0:0:1', 'DEV', 'SUCCESS', 0, '邮箱服务未配置，已生成开发验证码', NULL, '0dc2ede6cce9498d876f173f8480ab5a', '2026-06-29 15:18:20.451270');
INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (2, 'codex-rate-162100@example.com', 'REGISTER', 'EMAIL', '0:0:0:0:0:0:0:1', 'DEV', 'SUCCESS', 0, '邮箱服务未配置，已生成开发验证码', NULL, '3d8b959b46fe4748b51f39681c30a0a0', '2026-06-29 16:21:01.093586');
INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (4, 'codex-block-163352@example.com', 'REGISTER', 'EMAIL', '0:0:0:0:0:0:0:1', 'DEV', 'SUCCESS', 0, '邮箱服务未配置，已生成开发验证码', NULL, '2f59d34a76b945adbd22ac1175523782', '2026-06-29 16:33:52.733385');
INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (5, 'codex-block-163352@example.com', 'REGISTER', 'EMAIL', '0:0:0:0:0:0:0:1', 'BLOCKED', 'BLOCKED', 0, '验证码发送请求被系统限流', '验证码发送过于频繁', '37dda4e28c144cc6a39cfe05fb432a68', '2026-06-29 16:33:53.136017');
INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (6, 'CHMgGa@163.com', 'RESET_PASSWORD', 'EMAIL', '0:0:0:0:0:0:0:1', 'DEV', 'SUCCESS', 0, '邮箱服务未配置，已生成开发验证码', NULL, 'a2a50c6ef87a40d4bab1f1eefa3b8a85', '2026-06-29 19:05:47.335319');
INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (7, 'CHMgGa@163.com', 'RESET_PASSWORD', 'EMAIL', '0:0:0:0:0:0:0:1', 'BLOCKED', 'BLOCKED', 0, '验证码发送请求被系统限流', '验证码发送过于频繁', '6fc78dab4a2d4e02ada55c0de6bd851a', '2026-06-29 19:05:53.305494');
INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (8, 'wyvern06@163.com', 'RESET_PASSWORD', 'EMAIL', '0:0:0:0:0:0:0:1', 'DEV', 'SUCCESS', 0, '邮箱服务未配置，已生成开发验证码', NULL, 'b9219d53c8a24e0baac120b577bc0edb', '2026-06-29 19:19:46.810803');
INSERT INTO public.verification_send_log (id, receiver, scene, channel, client_ip, delivery_mode, status, retry_count, provider_message, error_message, request_trace_id, created_at) VALUES (9, 'wyvern06@163.com', 'RESET_PASSWORD', 'EMAIL', '0:0:0:0:0:0:0:1', 'REAL', 'SUCCESS', 0, '验证码已发送至邮箱', NULL, 'e1cb9e49c15b4ab1939c26c1b862da2d', '2026-06-29 19:24:11.212762');


--
-- Name: alert_action_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alert_action_log_id_seq', 1, false);


--
-- Name: alert_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alert_rule_id_seq', 2, true);


--
-- Name: app_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_user_id_seq', 5, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 5, true);


--
-- Name: auth_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_role_id_seq', 2, true);


--
-- Name: auth_role_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_role_permission_id_seq', 6, true);


--
-- Name: auth_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_role_id_seq', 7, true);


--
-- Name: device_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.device_type_id_seq', 4, true);


--
-- Name: farmer_greenhouse_binding_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.farmer_greenhouse_binding_id_seq', 5, true);


--
-- Name: feedback_conversation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.feedback_conversation_id_seq', 1, true);


--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.feedback_id_seq', 1, true);


--
-- Name: feedback_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.feedback_message_id_seq', 1, true);


--
-- Name: greenhouse_alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.greenhouse_alert_id_seq', 5, true);


--
-- Name: greenhouse_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.greenhouse_device_id_seq', 10, true);


--
-- Name: greenhouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.greenhouse_id_seq', 7, true);


--
-- Name: operation_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.operation_log_id_seq', 1316, true);


--
-- Name: production_batch_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.production_batch_event_id_seq', 3, true);


--
-- Name: production_batch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.production_batch_id_seq', 5, true);


--
-- Name: sys_dict_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_dict_item_id_seq', 12, true);


--
-- Name: sys_dict_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_dict_type_id_seq', 4, true);


--
-- Name: sys_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_permission_id_seq', 1, false);


--
-- Name: sys_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_role_id_seq', 1, false);


--
-- Name: sys_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_user_id_seq', 1, false);


--
-- Name: telemetry_snapshot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.telemetry_snapshot_id_seq', 73, true);


--
-- Name: traceability_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.traceability_record_id_seq', 3, true);


--
-- Name: verification_code_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.verification_code_id_seq', 10, true);


--
-- Name: verification_send_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.verification_send_log_id_seq', 9, true);


--
-- Name: alert_action_log alert_action_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_action_log
    ADD CONSTRAINT alert_action_log_pkey PRIMARY KEY (id);


--
-- Name: alert_rule alert_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rule
    ADD CONSTRAINT alert_rule_pkey PRIMARY KEY (id);


--
-- Name: alert_rule alert_rule_rule_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rule
    ADD CONSTRAINT alert_rule_rule_code_key UNIQUE (rule_code);


--
-- Name: app_session app_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_session
    ADD CONSTRAINT app_session_pkey PRIMARY KEY (token);


--
-- Name: app_user app_user_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_email_key UNIQUE (email);


--
-- Name: app_user app_user_phone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_phone_key UNIQUE (phone);


--
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (id);


--
-- Name: app_user app_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_username_key UNIQUE (username);


--
-- Name: auth_permission auth_permission_permission_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_permission_code_key UNIQUE (permission_code);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_role_permission auth_role_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role_permission
    ADD CONSTRAINT auth_role_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_role_permission auth_role_permission_role_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role_permission
    ADD CONSTRAINT auth_role_permission_role_id_permission_id_key UNIQUE (role_id, permission_id);


--
-- Name: auth_role auth_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_pkey PRIMARY KEY (id);


--
-- Name: auth_role auth_role_role_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_role_code_key UNIQUE (role_code);


--
-- Name: auth_user_role auth_user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_role
    ADD CONSTRAINT auth_user_role_pkey PRIMARY KEY (id);


--
-- Name: auth_user_role auth_user_role_user_id_role_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_role
    ADD CONSTRAINT auth_user_role_user_id_role_id_key UNIQUE (user_id, role_id);


--
-- Name: device_type device_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_type
    ADD CONSTRAINT device_type_pkey PRIMARY KEY (id);


--
-- Name: device_type device_type_type_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_type
    ADD CONSTRAINT device_type_type_code_key UNIQUE (type_code);


--
-- Name: farmer_greenhouse_binding farmer_greenhouse_binding_greenhouse_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmer_greenhouse_binding
    ADD CONSTRAINT farmer_greenhouse_binding_greenhouse_id_key UNIQUE (greenhouse_id);


--
-- Name: farmer_greenhouse_binding farmer_greenhouse_binding_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmer_greenhouse_binding
    ADD CONSTRAINT farmer_greenhouse_binding_pkey PRIMARY KEY (id);


--
-- Name: feedback_conversation feedback_conversation_farmer_user_id_admin_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_conversation
    ADD CONSTRAINT feedback_conversation_farmer_user_id_admin_user_id_key UNIQUE (farmer_user_id, admin_user_id);


--
-- Name: feedback_conversation feedback_conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_conversation
    ADD CONSTRAINT feedback_conversation_pkey PRIMARY KEY (id);


--
-- Name: feedback_message feedback_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_message
    ADD CONSTRAINT feedback_message_pkey PRIMARY KEY (id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: greenhouse_alert greenhouse_alert_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_alert
    ADD CONSTRAINT greenhouse_alert_pkey PRIMARY KEY (id);


--
-- Name: greenhouse_device greenhouse_device_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_device
    ADD CONSTRAINT greenhouse_device_pkey PRIMARY KEY (id);


--
-- Name: greenhouse greenhouse_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse
    ADD CONSTRAINT greenhouse_pkey PRIMARY KEY (id);


--
-- Name: operation_log operation_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operation_log
    ADD CONSTRAINT operation_log_pkey PRIMARY KEY (id);


--
-- Name: production_batch production_batch_batch_no_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.production_batch
    ADD CONSTRAINT production_batch_batch_no_key UNIQUE (batch_no);


--
-- Name: production_batch_event production_batch_event_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.production_batch_event
    ADD CONSTRAINT production_batch_event_pkey PRIMARY KEY (id);


--
-- Name: production_batch production_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.production_batch
    ADD CONSTRAINT production_batch_pkey PRIMARY KEY (id);


--
-- Name: sys_dict_item sys_dict_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_dict_item
    ADD CONSTRAINT sys_dict_item_pkey PRIMARY KEY (id);


--
-- Name: sys_dict_item sys_dict_item_type_code_item_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_dict_item
    ADD CONSTRAINT sys_dict_item_type_code_item_code_key UNIQUE (type_code, item_code);


--
-- Name: sys_dict_type sys_dict_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_dict_type
    ADD CONSTRAINT sys_dict_type_pkey PRIMARY KEY (id);


--
-- Name: sys_dict_type sys_dict_type_type_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_dict_type
    ADD CONSTRAINT sys_dict_type_type_code_key UNIQUE (type_code);


--
-- Name: sys_permission sys_permission_permission_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_permission
    ADD CONSTRAINT sys_permission_permission_code_key UNIQUE (permission_code);


--
-- Name: sys_permission sys_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_permission
    ADD CONSTRAINT sys_permission_pkey PRIMARY KEY (id);


--
-- Name: sys_role sys_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_role
    ADD CONSTRAINT sys_role_pkey PRIMARY KEY (id);


--
-- Name: sys_role sys_role_role_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_role
    ADD CONSTRAINT sys_role_role_code_key UNIQUE (role_code);


--
-- Name: sys_user sys_user_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_email_key UNIQUE (email);


--
-- Name: sys_user sys_user_phone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_phone_key UNIQUE (phone);


--
-- Name: sys_user sys_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_pkey PRIMARY KEY (id);


--
-- Name: sys_user sys_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_username_key UNIQUE (username);


--
-- Name: telemetry_snapshot telemetry_snapshot_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telemetry_snapshot
    ADD CONSTRAINT telemetry_snapshot_pkey PRIMARY KEY (id);


--
-- Name: traceability_record traceability_record_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traceability_record
    ADD CONSTRAINT traceability_record_pkey PRIMARY KEY (id);


--
-- Name: verification_code verification_code_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_code
    ADD CONSTRAINT verification_code_pkey PRIMARY KEY (id);


--
-- Name: verification_send_log verification_send_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_send_log
    ADD CONSTRAINT verification_send_log_pkey PRIMARY KEY (id);


--
-- Name: idx_alert_action_alert; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alert_action_alert ON public.alert_action_log USING btree (alert_id, created_at DESC);


--
-- Name: idx_alert_greenhouse_status_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alert_greenhouse_status_time ON public.greenhouse_alert USING btree (greenhouse_id, status, occurred_at DESC, deleted);


--
-- Name: idx_alert_rule; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alert_rule ON public.greenhouse_alert USING btree (rule_id);


--
-- Name: idx_alert_rule_metric_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alert_rule_metric_enabled ON public.alert_rule USING btree (metric_key, enabled, deleted);


--
-- Name: idx_alert_status_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alert_status_level ON public.greenhouse_alert USING btree (status, level);


--
-- Name: idx_app_session_user_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_session_user_expires ON public.app_session USING btree (user_id, expires_at DESC);


--
-- Name: idx_batch_event_batch_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_batch_event_batch_order ON public.production_batch_event USING btree (batch_id, sort_order, event_time);


--
-- Name: idx_batch_greenhouse_status_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_batch_greenhouse_status_time ON public.production_batch USING btree (greenhouse_id, status, started_at DESC, deleted);


--
-- Name: idx_batch_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_batch_no ON public.production_batch USING btree (batch_no);


--
-- Name: idx_device_type_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_device_type_category ON public.device_type USING btree (category, enabled, deleted);


--
-- Name: idx_dict_item_type_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dict_item_type_enabled ON public.sys_dict_item USING btree (type_code, enabled, deleted);


--
-- Name: idx_farmer_greenhouse_farmer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_farmer_greenhouse_farmer ON public.farmer_greenhouse_binding USING btree (farmer_user_id, deleted);


--
-- Name: idx_farmer_greenhouse_greenhouse; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_farmer_greenhouse_greenhouse ON public.farmer_greenhouse_binding USING btree (greenhouse_id, deleted);


--
-- Name: idx_feedback_conversation_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedback_conversation_admin ON public.feedback_conversation USING btree (admin_user_id, deleted, last_message_at DESC);


--
-- Name: idx_feedback_conversation_farmer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedback_conversation_farmer ON public.feedback_conversation USING btree (farmer_user_id, deleted, last_message_at DESC);


--
-- Name: idx_feedback_message_conversation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedback_message_conversation ON public.feedback_message USING btree (conversation_id, created_at);


--
-- Name: idx_feedback_status_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedback_status_time ON public.feedback USING btree (status, created_at DESC, deleted);


--
-- Name: idx_greenhouse_device_greenhouse_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_greenhouse_device_greenhouse_status ON public.greenhouse_device USING btree (greenhouse_id, status, deleted);


--
-- Name: idx_greenhouse_device_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_greenhouse_device_type ON public.greenhouse_device USING btree (device_type_id);


--
-- Name: idx_greenhouse_owner_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_greenhouse_owner_status ON public.greenhouse USING btree (owner_user_id, status, deleted);


--
-- Name: idx_operation_log_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_operation_log_created_at ON public.operation_log USING btree (created_at DESC);


--
-- Name: idx_operation_log_module_success_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_operation_log_module_success_time ON public.operation_log USING btree (module_name, success, created_at DESC);


--
-- Name: idx_operation_log_trace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_operation_log_trace ON public.operation_log USING btree (trace_id);


--
-- Name: idx_operation_log_user_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_operation_log_user_time ON public.operation_log USING btree (username, created_at DESC);


--
-- Name: idx_role_permission_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_permission_role ON public.auth_role_permission USING btree (role_id);


--
-- Name: idx_telemetry_greenhouse_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_telemetry_greenhouse_time ON public.telemetry_snapshot USING btree (greenhouse_id, collected_at DESC);


--
-- Name: idx_user_role_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_role_user ON public.auth_user_role USING btree (user_id);


--
-- Name: idx_verification_code_expires_used; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_verification_code_expires_used ON public.verification_code USING btree (expires_at, used);


--
-- Name: idx_verification_code_receiver_scene_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_verification_code_receiver_scene_time ON public.verification_code USING btree (receiver, scene, created_at DESC);


--
-- Name: idx_verification_send_ip_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_verification_send_ip_time ON public.verification_send_log USING btree (client_ip, created_at DESC);


--
-- Name: idx_verification_send_receiver_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_verification_send_receiver_time ON public.verification_send_log USING btree (receiver, created_at DESC);


--
-- Name: alert_action_log alert_action_log_alert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_action_log
    ADD CONSTRAINT alert_action_log_alert_id_fkey FOREIGN KEY (alert_id) REFERENCES public.greenhouse_alert(id);


--
-- Name: alert_action_log alert_action_log_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_action_log
    ADD CONSTRAINT alert_action_log_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.greenhouse_device(id);


--
-- Name: alert_action_log alert_action_log_notify_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_action_log
    ADD CONSTRAINT alert_action_log_notify_user_id_fkey FOREIGN KEY (notify_user_id) REFERENCES public.app_user(id);


--
-- Name: alert_rule alert_rule_device_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rule
    ADD CONSTRAINT alert_rule_device_type_id_fkey FOREIGN KEY (device_type_id) REFERENCES public.device_type(id);


--
-- Name: alert_rule alert_rule_greenhouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rule
    ADD CONSTRAINT alert_rule_greenhouse_id_fkey FOREIGN KEY (greenhouse_id) REFERENCES public.greenhouse(id);


--
-- Name: app_session app_session_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_session
    ADD CONSTRAINT app_session_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: auth_role_permission auth_role_permission_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role_permission
    ADD CONSTRAINT auth_role_permission_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id);


--
-- Name: auth_role_permission auth_role_permission_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_role_permission
    ADD CONSTRAINT auth_role_permission_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.auth_role(id);


--
-- Name: auth_user_role auth_user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_role
    ADD CONSTRAINT auth_user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.auth_role(id);


--
-- Name: auth_user_role auth_user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_role
    ADD CONSTRAINT auth_user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: farmer_greenhouse_binding farmer_greenhouse_binding_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmer_greenhouse_binding
    ADD CONSTRAINT farmer_greenhouse_binding_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.app_user(id);


--
-- Name: farmer_greenhouse_binding farmer_greenhouse_binding_farmer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmer_greenhouse_binding
    ADD CONSTRAINT farmer_greenhouse_binding_farmer_user_id_fkey FOREIGN KEY (farmer_user_id) REFERENCES public.app_user(id);


--
-- Name: farmer_greenhouse_binding farmer_greenhouse_binding_greenhouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmer_greenhouse_binding
    ADD CONSTRAINT farmer_greenhouse_binding_greenhouse_id_fkey FOREIGN KEY (greenhouse_id) REFERENCES public.greenhouse(id);


--
-- Name: feedback_conversation feedback_conversation_admin_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_conversation
    ADD CONSTRAINT feedback_conversation_admin_user_id_fkey FOREIGN KEY (admin_user_id) REFERENCES public.app_user(id);


--
-- Name: feedback_conversation feedback_conversation_farmer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_conversation
    ADD CONSTRAINT feedback_conversation_farmer_user_id_fkey FOREIGN KEY (farmer_user_id) REFERENCES public.app_user(id);


--
-- Name: feedback_message feedback_message_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_message
    ADD CONSTRAINT feedback_message_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.feedback_conversation(id);


--
-- Name: feedback_message feedback_message_receiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_message
    ADD CONSTRAINT feedback_message_receiver_user_id_fkey FOREIGN KEY (receiver_user_id) REFERENCES public.app_user(id);


--
-- Name: feedback_message feedback_message_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_message
    ADD CONSTRAINT feedback_message_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public.app_user(id);


--
-- Name: feedback feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: greenhouse_alert greenhouse_alert_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_alert
    ADD CONSTRAINT greenhouse_alert_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.greenhouse_device(id);


--
-- Name: greenhouse_alert greenhouse_alert_greenhouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_alert
    ADD CONSTRAINT greenhouse_alert_greenhouse_id_fkey FOREIGN KEY (greenhouse_id) REFERENCES public.greenhouse(id);


--
-- Name: greenhouse_alert greenhouse_alert_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_alert
    ADD CONSTRAINT greenhouse_alert_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.alert_rule(id);


--
-- Name: greenhouse_device greenhouse_device_device_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_device
    ADD CONSTRAINT greenhouse_device_device_type_id_fkey FOREIGN KEY (device_type_id) REFERENCES public.device_type(id);


--
-- Name: greenhouse_device greenhouse_device_greenhouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse_device
    ADD CONSTRAINT greenhouse_device_greenhouse_id_fkey FOREIGN KEY (greenhouse_id) REFERENCES public.greenhouse(id);


--
-- Name: greenhouse greenhouse_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.greenhouse
    ADD CONSTRAINT greenhouse_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.app_user(id);


--
-- Name: production_batch_event production_batch_event_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.production_batch_event
    ADD CONSTRAINT production_batch_event_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.production_batch(id);


--
-- Name: production_batch production_batch_greenhouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.production_batch
    ADD CONSTRAINT production_batch_greenhouse_id_fkey FOREIGN KEY (greenhouse_id) REFERENCES public.greenhouse(id);


--
-- Name: telemetry_snapshot telemetry_snapshot_greenhouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telemetry_snapshot
    ADD CONSTRAINT telemetry_snapshot_greenhouse_id_fkey FOREIGN KEY (greenhouse_id) REFERENCES public.greenhouse(id);


--
-- Name: traceability_record traceability_record_greenhouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traceability_record
    ADD CONSTRAINT traceability_record_greenhouse_id_fkey FOREIGN KEY (greenhouse_id) REFERENCES public.greenhouse(id);


--
-- Kingbase database dump complete
--

