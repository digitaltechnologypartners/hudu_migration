--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 12.2 (Debian 12.2-2.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    name character varying,
    stripe_customer_id character varying,
    stripe_subscription_id character varying,
    billing_successful boolean DEFAULT false,
    two_factor_auth_enforced boolean DEFAULT false,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    slug character varying,
    color character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    idle_timeout integer,
    logo_data character varying,
    theme integer DEFAULT 0,
    bulletin text,
    bulletin_updated_at timestamp without time zone,
    billing_type integer DEFAULT 0,
    custom_css text,
    licensing_key character varying,
    licensing_plan character varying,
    saml_issuer_url character varying,
    saml_login_endpoint character varying,
    saml_logout_endpoint character varying,
    saml_fingerprint character varying,
    saml_certificate text,
    saml_enabled boolean,
    saml_disable_password_access boolean,
    shared_logo_data text,
    saml_arn character varying,
    disable_sharing boolean DEFAULT false,
    favicon_data text,
    authentication_logo_data text,
    score_last_updated timestamp without time zone,
    default_password_length integer,
    default_time_zone character varying DEFAULT 'UTC'::character varying,
    completed_process_instances character varying,
    completed_process_instances_last_updated timestamp without time zone
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: agreements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agreements (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    sync_identifier character varying,
    contact_name character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    cancelled_date timestamp without time zone,
    agreement_type character varying,
    cancelled_flag boolean DEFAULT false,
    no_end_date_flag boolean DEFAULT false,
    cancel_reason text,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.agreements OWNER TO postgres;

--
-- Name: agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agreements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agreements_id_seq OWNER TO postgres;

--
-- Name: agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agreements_id_seq OWNED BY public.agreements.id;


--
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    email character varying,
    name character varying,
    alert_type integer DEFAULT 0,
    expiration_type integer DEFAULT 0,
    days_until integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    webhook_payload text,
    webhook_url text,
    stop_on_trigger boolean,
    include_archived_records boolean,
    company_id bigint
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alerts_id_seq OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_keys (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    name character varying,
    token character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password_access boolean DEFAULT false,
    destructive_actions boolean DEFAULT false,
    allowed_ips text,
    company_id bigint
);


ALTER TABLE public.api_keys OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_keys_id_seq OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articles (
    id bigint NOT NULL,
    account_id bigint,
    name character varying,
    slug character varying,
    content text,
    discarded_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    public_token character varying,
    is_template boolean DEFAULT false,
    company_id bigint,
    enable_sharing boolean,
    folder_id bigint,
    draft boolean,
    draft_title character varying,
    draft_content character varying,
    draft_autosaved_at timestamp without time zone,
    draft_folder_id bigint,
    read_only boolean DEFAULT false,
    article_template boolean,
    article_template_id bigint,
    is_upload boolean DEFAULT false
);


ALTER TABLE public.articles OWNER TO postgres;

--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.articles_id_seq OWNER TO postgres;

--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: asset_fields; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_fields (
    id bigint NOT NULL,
    asset_layout_field_id bigint NOT NULL,
    asset_id bigint NOT NULL,
    string_value character varying,
    boolean_value boolean,
    date_value timestamp without time zone,
    text_value text,
    encrypted_password_value character varying,
    encrypted_password_value_iv character varying,
    integer_value bigint,
    type character varying,
    linkable_type character varying,
    linkable_id bigint,
    domain_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password_updated_at timestamp without time zone,
    data jsonb
);


ALTER TABLE public.asset_fields OWNER TO postgres;

--
-- Name: asset_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_fields_id_seq OWNER TO postgres;

--
-- Name: asset_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_fields_id_seq OWNED BY public.asset_fields.id;


--
-- Name: asset_layout_fields; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_layout_fields (
    id bigint NOT NULL,
    asset_layout_id bigint,
    min integer,
    max integer,
    required boolean,
    "position" integer,
    label character varying,
    hint character varying,
    type character varying,
    expiration boolean DEFAULT false,
    options text,
    linkable_type character varying,
    linkable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_destroyed boolean DEFAULT false,
    show_in_list boolean DEFAULT false
);


ALTER TABLE public.asset_layout_fields OWNER TO postgres;

--
-- Name: asset_layout_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_layout_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_layout_fields_id_seq OWNER TO postgres;

--
-- Name: asset_layout_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_layout_fields_id_seq OWNED BY public.asset_layout_fields.id;


--
-- Name: asset_layouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_layouts (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    synced boolean DEFAULT false,
    synced_name character varying,
    color character varying,
    icon_color character varying,
    icon character varying,
    include_passwords boolean DEFAULT true,
    include_files boolean DEFAULT true,
    account_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active boolean DEFAULT false,
    field_names text[] DEFAULT '{}'::text[],
    include_comments boolean DEFAULT true,
    password_types text,
    integrator_id bigint,
    include_processes boolean DEFAULT true,
    description text,
    include_photos boolean,
    alternate_name character varying,
    sidebar_folder_id bigint,
    name_list text
);


ALTER TABLE public.asset_layouts OWNER TO postgres;

--
-- Name: asset_layouts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_layouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_layouts_id_seq OWNER TO postgres;

--
-- Name: asset_layouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_layouts_id_seq OWNED BY public.asset_layouts.id;


--
-- Name: asset_passwords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_passwords (
    id bigint NOT NULL,
    encrypted_password character varying,
    encrypted_password_iv character varying,
    description text,
    name character varying,
    asset_id bigint,
    discarded_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company_id bigint,
    account_id bigint,
    username character varying,
    password_type character varying,
    url character varying,
    slug character varying,
    password_updated_at timestamp without time zone,
    passwordable_id bigint,
    passwordable_type character varying,
    in_portal boolean DEFAULT false,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    color character varying,
    password_folder_id bigint
);


ALTER TABLE public.asset_passwords OWNER TO postgres;

--
-- Name: asset_passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_passwords_id_seq OWNER TO postgres;

--
-- Name: asset_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_passwords_id_seq OWNED BY public.asset_passwords.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    asset_layout_id bigint NOT NULL,
    slug character varying,
    name character varying,
    discarded_at timestamp without time zone,
    discarded_by_integration boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    integration_fields jsonb DEFAULT '{}'::jsonb,
    synced boolean DEFAULT false,
    sync_status integer,
    last_synced timestamp without time zone,
    sync_id integer,
    sync_type character varying,
    last_sync_message character varying,
    integrator_type character varying,
    integrator_id bigint,
    primary_mail character varying,
    primary_serial character varying,
    primary_manufacturer character varying,
    primary_model character varying,
    primary_mac character varying[] DEFAULT '{}'::character varying[]
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assets_id_seq OWNER TO postgres;

--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- Name: autotask_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autotask_products (
    id bigint NOT NULL,
    integrator_id bigint NOT NULL,
    autotask_id bigint,
    product_name character varying,
    product_manufacturer character varying,
    product_model character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.autotask_products OWNER TO postgres;

--
-- Name: autotask_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.autotask_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.autotask_products_id_seq OWNER TO postgres;

--
-- Name: autotask_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.autotask_products_id_seq OWNED BY public.autotask_products.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    account character varying,
    commentable_type character varying NOT NULL,
    commentable_id bigint NOT NULL,
    user_id bigint NOT NULL,
    editing_user_id bigint,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    slug character varying,
    name character varying,
    nickname character varying,
    address_line_1 character varying,
    address_line_2 character varying,
    city character varying,
    state character varying,
    zip character varying,
    country_name character varying,
    phone_number character varying,
    fax_number character varying,
    website character varying,
    notes text,
    integration_fields jsonb DEFAULT '{}'::jsonb,
    discarded_by_integration boolean DEFAULT false,
    synced boolean DEFAULT false,
    sync_status integer,
    last_synced timestamp without time zone,
    sync_id integer,
    discarded_at timestamp without time zone,
    account_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_sync_message character varying,
    identifier character varying,
    rating integer DEFAULT 1,
    logo_data text,
    office_licensing jsonb,
    parent_company_id bigint,
    id_number character varying,
    company_type character varying,
    lat double precision,
    lon double precision,
    address_changed timestamp without time zone
);


ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_article_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_article_templates (
    id bigint NOT NULL,
    article_id bigint NOT NULL,
    company_id bigint NOT NULL,
    account_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.company_article_templates OWNER TO postgres;

--
-- Name: company_article_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_article_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_article_templates_id_seq OWNER TO postgres;

--
-- Name: company_article_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_article_templates_id_seq OWNED BY public.company_article_templates.id;


--
-- Name: company_variables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_variables (
    id bigint NOT NULL,
    key character varying,
    value character varying,
    company_id bigint NOT NULL,
    account_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.company_variables OWNER TO postgres;

--
-- Name: company_variables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_variables_id_seq OWNER TO postgres;

--
-- Name: company_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_variables_id_seq OWNED BY public.company_variables.id;


--
-- Name: configuration_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuration_types (
    id bigint NOT NULL,
    integrator_id bigint,
    name character varying,
    type_id integer,
    skipped boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.configuration_types OWNER TO postgres;

--
-- Name: configuration_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configuration_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.configuration_types_id_seq OWNER TO postgres;

--
-- Name: configuration_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.configuration_types_id_seq OWNED BY public.configuration_types.id;


--
-- Name: custom_fast_facts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.custom_fast_facts (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    title character varying,
    message character varying,
    content text,
    shade character varying,
    icon character varying,
    image_url character varying,
    content_link character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.custom_fast_facts OWNER TO postgres;

--
-- Name: custom_fast_facts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.custom_fast_facts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_fast_facts_id_seq OWNER TO postgres;

--
-- Name: custom_fast_facts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.custom_fast_facts_id_seq OWNED BY public.custom_fast_facts.id;


--
-- Name: dns_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dns_details (
    id bigint NOT NULL,
    website_id bigint NOT NULL,
    a jsonb,
    mx jsonb,
    txt jsonb,
    aaaa jsonb,
    ns jsonb,
    soa jsonb,
    ptr jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    last_check_code character varying,
    last_check_error boolean,
    last_checked_at timestamp without time zone
);


ALTER TABLE public.dns_details OWNER TO postgres;

--
-- Name: dns_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dns_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dns_details_id_seq OWNER TO postgres;

--
-- Name: dns_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dns_details_id_seq OWNED BY public.dns_details.id;


--
-- Name: domain_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domain_histories (
    id bigint NOT NULL,
    domain_id bigint NOT NULL,
    down_at timestamp without time zone,
    up_at timestamp without time zone,
    checked_status integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status_code integer
);


ALTER TABLE public.domain_histories OWNER TO postgres;

--
-- Name: domain_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.domain_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_histories_id_seq OWNER TO postgres;

--
-- Name: domain_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.domain_histories_id_seq OWNED BY public.domain_histories.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domains (
    id bigint NOT NULL,
    checked_status integer DEFAULT 0,
    info_status integer DEFAULT 0,
    account_id bigint,
    name character varying,
    last_checked timestamp without time zone,
    company_id bigint,
    a_records jsonb,
    mx_records jsonb,
    txt_records jsonb,
    aaaa_records jsonb,
    ns_records jsonb,
    soa_records jsonb,
    ptr_records jsonb,
    whois_registrar character varying,
    whois_status character varying,
    whois_created timestamp without time zone,
    whois_expires timestamp without time zone,
    whois_updated timestamp without time zone,
    whois_available boolean DEFAULT true,
    whois_contacts jsonb,
    whois_raw text,
    whois_nameservers jsonb,
    last_refresh_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sent_notifications boolean DEFAULT false,
    certificate text,
    ssl_invalid_error character varying,
    not_before timestamp without time zone,
    not_after timestamp without time zone,
    public_key character varying,
    version character varying,
    subject character varying,
    serial character varying,
    issuer character varying,
    signature_algorithm character varying,
    ssl_valid boolean DEFAULT false,
    pause_monitoring boolean DEFAULT false
);


ALTER TABLE public.domains OWNER TO postgres;

--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domains_id_seq OWNER TO postgres;

--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.domains_id_seq OWNED BY public.domains.id;


--
-- Name: dynamic_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dynamic_jobs (
    id bigint NOT NULL,
    account_id bigint,
    next_run_at timestamp without time zone NOT NULL,
    klass character varying NOT NULL,
    cron_expression character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.dynamic_jobs OWNER TO postgres;

--
-- Name: dynamic_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dynamic_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dynamic_jobs_id_seq OWNER TO postgres;

--
-- Name: dynamic_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dynamic_jobs_id_seq OWNED BY public.dynamic_jobs.id;


--
-- Name: expirations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.expirations (
    id bigint NOT NULL,
    date date,
    expirationable_type character varying,
    expirationable_id bigint,
    account_id bigint,
    company_id bigint,
    asset_layout_field_id bigint,
    sync_id integer,
    discarded_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    expiration_type integer DEFAULT 0,
    asset_field_id bigint
);


ALTER TABLE public.expirations OWNER TO postgres;

--
-- Name: expirations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.expirations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.expirations_id_seq OWNER TO postgres;

--
-- Name: expirations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.expirations_id_seq OWNED BY public.expirations.id;


--
-- Name: export_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.export_items (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    export_id bigint NOT NULL,
    filename character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.export_items OWNER TO postgres;

--
-- Name: export_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.export_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.export_items_id_seq OWNER TO postgres;

--
-- Name: export_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.export_items_id_seq OWNED BY public.export_items.id;


--
-- Name: exports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exports (
    id bigint NOT NULL,
    account_id bigint,
    s3_bucket character varying,
    s3_public character varying,
    s3_private character varying,
    s3_region character varying,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    file_data text,
    is_pdf boolean,
    mask_passwords boolean
);


ALTER TABLE public.exports OWNER TO postgres;

--
-- Name: exports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exports_id_seq OWNER TO postgres;

--
-- Name: exports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exports_id_seq OWNED BY public.exports.id;


--
-- Name: flag_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flag_types (
    id bigint NOT NULL,
    name character varying,
    color character varying,
    slug character varying,
    account_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.flag_types OWNER TO postgres;

--
-- Name: flag_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flag_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flag_types_id_seq OWNER TO postgres;

--
-- Name: flag_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flag_types_id_seq OWNED BY public.flag_types.id;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flags (
    id bigint NOT NULL,
    flag_type_id bigint,
    user_id bigint,
    account_id bigint,
    active boolean DEFAULT false,
    description text,
    flagable_type character varying,
    flagable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company_id bigint
);


ALTER TABLE public.flags OWNER TO postgres;

--
-- Name: flags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flags_id_seq OWNER TO postgres;

--
-- Name: flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flags_id_seq OWNED BY public.flags.id;


--
-- Name: folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.folders (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    name character varying,
    icon character varying,
    company_id bigint,
    ancestry character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description text
);


ALTER TABLE public.folders OWNER TO postgres;

--
-- Name: folders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.folders_id_seq OWNER TO postgres;

--
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.folders_id_seq OWNED BY public.folders.id;


--
-- Name: gold_standards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gold_standards (
    id bigint NOT NULL,
    standardable_type character varying,
    standardable_id bigint,
    asset_layout_id bigint,
    account_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.gold_standards OWNER TO postgres;

--
-- Name: gold_standards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gold_standards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gold_standards_id_seq OWNER TO postgres;

--
-- Name: gold_standards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gold_standards_id_seq OWNED BY public.gold_standards.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    account_id bigint,
    name character varying,
    slug character varying,
    use_schedule boolean DEFAULT false,
    access_start timestamp without time zone,
    access_end timestamp without time zone,
    time_zone character varying DEFAULT 'UTC'::character varying,
    monday_login boolean DEFAULT false,
    tuesday_login boolean DEFAULT false,
    wednesday_login boolean DEFAULT false,
    thursday_login boolean DEFAULT false,
    friday_login boolean DEFAULT false,
    saturday_login boolean DEFAULT false,
    sunday_login boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    remove_global_kb_access boolean,
    remove_personal_vault_access boolean,
    remove_access_to_passwords boolean,
    remove_access_to_otp_secrets boolean,
    create_client_dashboard_view boolean,
    remove_share_ability boolean,
    switch_to_allow_list boolean,
    denied_asset_layout_ids bigint[] DEFAULT '{}'::bigint[],
    remove_agreements boolean,
    "default" boolean
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: hits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hits (
    id bigint NOT NULL,
    count integer,
    user_id bigint,
    account_id bigint,
    hitable_type character varying,
    hitable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company_id bigint
);


ALTER TABLE public.hits OWNER TO postgres;

--
-- Name: hits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hits_id_seq OWNER TO postgres;

--
-- Name: hits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hits_id_seq OWNED BY public.hits.id;


--
-- Name: imported_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imported_records (
    id bigint NOT NULL,
    import_id bigint,
    imported_recordable_type character varying,
    imported_recordable_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.imported_records OWNER TO postgres;

--
-- Name: imported_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.imported_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imported_records_id_seq OWNER TO postgres;

--
-- Name: imported_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.imported_records_id_seq OWNED BY public.imported_records.id;


--
-- Name: imports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imports (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    matching boolean DEFAULT false,
    data jsonb,
    import_type character varying,
    status integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    asset_layout_id bigint,
    asset_layout_name character varying
);


ALTER TABLE public.imports OWNER TO postgres;

--
-- Name: imports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imports_id_seq OWNER TO postgres;

--
-- Name: imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.imports_id_seq OWNED BY public.imports.id;


--
-- Name: integrator_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.integrator_cards (
    id bigint NOT NULL,
    integrator_id bigint NOT NULL,
    asset_id bigint,
    sync_type character varying,
    sync_id integer,
    last_synced timestamp without time zone,
    sync_status integer DEFAULT 0,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    sync_identifier character varying,
    primary_mail character varying,
    report_refresh_date timestamp without time zone,
    is_deleted boolean,
    deleted_date timestamp without time zone,
    has_exchange_license boolean,
    has_onedrive_license boolean,
    has_sharepoint_license boolean,
    has_skype_for_business_license boolean,
    has_yammer_license boolean,
    has_teams_license boolean,
    exchange_last_activity_date timestamp without time zone,
    onedrive_last_activity_date timestamp without time zone,
    sharepoint_last_activity_date timestamp without time zone,
    skype_for_business_last_activity_date timestamp without time zone,
    yammer_last_activity_date timestamp without time zone,
    teams_last_activity_date timestamp without time zone,
    exchange_license_assign_date timestamp without time zone,
    onedrive_license_assign_date timestamp without time zone,
    sharepoint_license_assign_date timestamp without time zone,
    skype_for_business_license_assign_date timestamp without time zone,
    yammer_license_assign_date timestamp without time zone,
    teams_license_assign_date timestamp without time zone,
    storage_used_byte bigint,
    issue_warning_quota_byte bigint,
    prohibit_send_quota_byte bigint,
    prohibit_send_receive_quota_byte bigint,
    assigned_products text[] DEFAULT '{}'::text[],
    primary_serial character varying,
    primary_model character varying,
    primary_manufacturer character varying,
    primary_mac character varying[] DEFAULT '{}'::character varying[],
    primary_phone character varying,
    important_contact boolean DEFAULT false
);


ALTER TABLE public.integrator_cards OWNER TO postgres;

--
-- Name: integrator_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.integrator_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.integrator_cards_id_seq OWNER TO postgres;

--
-- Name: integrator_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.integrator_cards_id_seq OWNED BY public.integrator_cards.id;


--
-- Name: integrators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.integrators (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    integration_slug character varying,
    active boolean DEFAULT false,
    last_synced_at timestamp without time zone,
    password character varying,
    key character varying,
    api_domain character varying,
    api_company character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    next_run_at timestamp without time zone,
    configuration_types jsonb,
    settings jsonb DEFAULT '{}'::jsonb,
    mapped_layout_1 integer,
    mapped_layout_2 integer,
    mapped_layout_3 integer,
    mapped_layout_4 integer,
    mapped_layout_5 integer,
    status integer DEFAULT 0,
    company_id bigint
);


ALTER TABLE public.integrators OWNER TO postgres;

--
-- Name: integrators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.integrators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.integrators_id_seq OWNER TO postgres;

--
-- Name: integrators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.integrators_id_seq OWNED BY public.integrators.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invitations (
    id bigint NOT NULL,
    user_id bigint,
    token character varying,
    activated boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.invitations OWNER TO postgres;

--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invitations_id_seq OWNER TO postgres;

--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invitations_id_seq OWNED BY public.invitations.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id bigint NOT NULL,
    account_id bigint,
    message character varying,
    logable_type character varying,
    logable_id bigint,
    record_type character varying,
    record_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_id_seq OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: matchers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matchers (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    integrator_id bigint NOT NULL,
    company_id bigint,
    potential_company_id integer,
    sync_id integer,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    identifier character varying
);


ALTER TABLE public.matchers OWNER TO postgres;

--
-- Name: matchers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matchers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.matchers_id_seq OWNER TO postgres;

--
-- Name: matchers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matchers_id_seq OWNED BY public.matchers.id;


--
-- Name: password_folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_folders (
    id bigint NOT NULL,
    name character varying,
    security integer DEFAULT 0,
    add_to_portal boolean DEFAULT false,
    description text,
    slug character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    allowed_groups bigint[] DEFAULT '{}'::bigint[],
    company_id bigint
);


ALTER TABLE public.password_folders OWNER TO postgres;

--
-- Name: password_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.password_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.password_folders_id_seq OWNER TO postgres;

--
-- Name: password_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.password_folders_id_seq OWNED BY public.password_folders.id;


--
-- Name: password_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_requests (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    portal_id bigint NOT NULL,
    requestable_type character varying NOT NULL,
    requestable_id bigint NOT NULL,
    description text,
    discarded_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.password_requests OWNER TO postgres;

--
-- Name: password_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.password_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.password_requests_id_seq OWNER TO postgres;

--
-- Name: password_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.password_requests_id_seq OWNED BY public.password_requests.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pg_search_documents (
    id bigint NOT NULL,
    content text,
    company_id integer,
    discarded_at timestamp without time zone,
    searchable_type character varying,
    searchable_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.pg_search_documents OWNER TO postgres;

--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pg_search_documents_id_seq OWNER TO postgres;

--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.photos (
    id bigint NOT NULL,
    photoable_type character varying,
    photoable_id bigint,
    account_id bigint,
    file_data text,
    caption character varying,
    discarded_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.photos OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photos_id_seq OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.photos_id_seq OWNED BY public.photos.id;


--
-- Name: pins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pins (
    id bigint NOT NULL,
    pinable_type character varying NOT NULL,
    pinable_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    "position" integer
);


ALTER TABLE public.pins OWNER TO postgres;

--
-- Name: pins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pins_id_seq OWNER TO postgres;

--
-- Name: pins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pins_id_seq OWNED BY public.pins.id;


--
-- Name: portal_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.portal_items (
    id bigint NOT NULL,
    portal_id bigint NOT NULL,
    portalable_type character varying NOT NULL,
    portalable_id bigint NOT NULL,
    asset_layout_id bigint,
    pin boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.portal_items OWNER TO postgres;

--
-- Name: portal_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.portal_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.portal_items_id_seq OWNER TO postgres;

--
-- Name: portal_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.portal_items_id_seq OWNED BY public.portal_items.id;


--
-- Name: portal_links; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.portal_links (
    id bigint NOT NULL,
    name character varying,
    url character varying,
    new_tab boolean DEFAULT false,
    description text,
    portal_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.portal_links OWNER TO postgres;

--
-- Name: portal_links_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.portal_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.portal_links_id_seq OWNER TO postgres;

--
-- Name: portal_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.portal_links_id_seq OWNED BY public.portal_links.id;


--
-- Name: portals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.portals (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    active boolean DEFAULT false,
    layout integer DEFAULT 0,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.portals OWNER TO postgres;

--
-- Name: portals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.portals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.portals_id_seq OWNER TO postgres;

--
-- Name: portals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.portals_id_seq OWNED BY public.portals.id;


--
-- Name: procedure_tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedure_tasks (
    id bigint NOT NULL,
    procedure_id bigint NOT NULL,
    name character varying,
    description text,
    "position" integer,
    completed boolean DEFAULT false,
    user_id bigint,
    completed_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    completion_notes text
);


ALTER TABLE public.procedure_tasks OWNER TO postgres;

--
-- Name: procedure_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procedure_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedure_tasks_id_seq OWNER TO postgres;

--
-- Name: procedure_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.procedure_tasks_id_seq OWNED BY public.procedure_tasks.id;


--
-- Name: procedures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedures (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    description text,
    discarded_at timestamp without time zone,
    template boolean DEFAULT false,
    company_id bigint,
    account_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    asset_id bigint,
    parent_procedure_id integer,
    share_token character varying,
    global_template_id bigint,
    remove_completion_ability boolean,
    featured boolean,
    autofeatured boolean
);


ALTER TABLE public.procedures OWNER TO postgres;

--
-- Name: procedures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procedures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedures_id_seq OWNER TO postgres;

--
-- Name: procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.procedures_id_seq OWNED BY public.procedures.id;


--
-- Name: public_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_photos (
    id bigint NOT NULL,
    image_first_url text,
    image_data text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    record_type character varying,
    record_id bigint
);


ALTER TABLE public.public_photos OWNER TO postgres;

--
-- Name: public_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_photos_id_seq OWNER TO postgres;

--
-- Name: public_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_photos_id_seq OWNED BY public.public_photos.id;


--
-- Name: pwned_passwords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pwned_passwords (
    id bigint NOT NULL,
    count integer,
    pwned boolean DEFAULT false,
    company_id bigint NOT NULL,
    account_id bigint NOT NULL,
    asset_password_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    asset_field_id bigint
);


ALTER TABLE public.pwned_passwords OWNER TO postgres;

--
-- Name: pwned_passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pwned_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pwned_passwords_id_seq OWNER TO postgres;

--
-- Name: pwned_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pwned_passwords_id_seq OWNED BY public.pwned_passwords.id;


--
-- Name: recordings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recordings (
    id bigint NOT NULL,
    details jsonb DEFAULT '{}'::jsonb,
    integration_fields jsonb DEFAULT '{}'::jsonb,
    action character varying,
    longitude double precision,
    latitude double precision,
    address character varying,
    city character varying,
    state character varying,
    state_code character varying,
    postal_code character varying,
    country character varying,
    country_code character varying,
    user_agent character varying,
    ip_address character varying,
    token character varying,
    user_id bigint,
    account_id bigint,
    company_id bigint,
    recordingable_type character varying,
    recordingable_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    old_name character varying,
    app_type integer DEFAULT 0
);


ALTER TABLE public.recordings OWNER TO postgres;

--
-- Name: recordings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recordings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recordings_id_seq OWNER TO postgres;

--
-- Name: recordings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recordings_id_seq OWNED BY public.recordings.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relations (
    id bigint NOT NULL,
    description text,
    fromable_type character varying,
    fromable_id bigint,
    toable_type character varying,
    toable_id bigint,
    is_inverse boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);


ALTER TABLE public.relations OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relations_id_seq OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relations_id_seq OWNED BY public.relations.id;


--
-- Name: restrictions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restrictions (
    id bigint NOT NULL,
    group_id bigint,
    restricted boolean,
    restrictable_type character varying,
    restrictable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.restrictions OWNER TO postgres;

--
-- Name: restrictions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restrictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restrictions_id_seq OWNER TO postgres;

--
-- Name: restrictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restrictions_id_seq OWNED BY public.restrictions.id;


--
-- Name: rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rules (
    id bigint NOT NULL,
    integrator_id bigint NOT NULL,
    configuration_type_id bigint NOT NULL,
    asset_layout_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    new_asset_layout_name character varying
);


ALTER TABLE public.rules OWNER TO postgres;

--
-- Name: rules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rules_id_seq OWNER TO postgres;

--
-- Name: rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rules_id_seq OWNED BY public.rules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: secure_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.secure_notes (
    id bigint NOT NULL,
    note text,
    expiration_date timestamp without time zone,
    company_id bigint NOT NULL,
    first_view boolean DEFAULT false,
    label character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.secure_notes OWNER TO postgres;

--
-- Name: secure_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.secure_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.secure_notes_id_seq OWNER TO postgres;

--
-- Name: secure_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.secure_notes_id_seq OWNED BY public.secure_notes.id;


--
-- Name: shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shares (
    id bigint NOT NULL,
    shareable_type character varying,
    shareable_id bigint,
    notes text,
    token character varying,
    expire_in bigint,
    include_passwords boolean DEFAULT true,
    include_files boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    one_time_expire boolean DEFAULT false,
    include_username boolean DEFAULT false,
    include_otp boolean,
    include_url boolean
);


ALTER TABLE public.shares OWNER TO postgres;

--
-- Name: shares_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shares_id_seq OWNER TO postgres;

--
-- Name: shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shares_id_seq OWNED BY public.shares.id;


--
-- Name: sidebar_folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sidebar_folders (
    id bigint NOT NULL,
    icon character varying,
    name character varying,
    color character varying,
    icon_color character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.sidebar_folders OWNER TO postgres;

--
-- Name: sidebar_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sidebar_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sidebar_folders_id_seq OWNER TO postgres;

--
-- Name: sidebar_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sidebar_folders_id_seq OWNED BY public.sidebar_folders.id;


--
-- Name: ssl_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ssl_details (
    id bigint NOT NULL,
    website_id bigint NOT NULL,
    certificate text,
    certificate_valid boolean DEFAULT false,
    invalid_error character varying,
    not_before timestamp without time zone,
    not_after timestamp without time zone,
    public_key character varying,
    version character varying,
    subject character varying,
    serial character varying,
    issuer character varying,
    signature_algorithm character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    last_check_code character varying,
    last_check_error boolean,
    last_checked_at timestamp without time zone
);


ALTER TABLE public.ssl_details OWNER TO postgres;

--
-- Name: ssl_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ssl_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ssl_details_id_seq OWNER TO postgres;

--
-- Name: ssl_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ssl_details_id_seq OWNED BY public.ssl_details.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    company_id bigint NOT NULL,
    tagable_type character varying,
    tagable_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uploads (
    id bigint NOT NULL,
    file_data character varying,
    uploadable_type character varying,
    uploadable_id bigint,
    account_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    discarded_at timestamp without time zone,
    name character varying
);


ALTER TABLE public.uploads OWNER TO postgres;

--
-- Name: uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uploads_id_seq OWNER TO postgres;

--
-- Name: uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uploads_id_seq OWNED BY public.uploads.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    otp_backup_codes character varying[],
    consumed_timestep integer,
    otp_required_for_login boolean DEFAULT false,
    employee boolean DEFAULT false,
    unconfirmed_otp_secret character varying,
    security_level integer DEFAULT 0,
    first_name character varying,
    last_name character varying,
    phone_number character varying,
    random_number_for_avatar integer DEFAULT 1,
    slug character varying,
    time_zone character varying DEFAULT 'UTC'::character varying,
    accepted_invite boolean DEFAULT false,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    account_id bigint,
    group_id bigint,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    avatar_data character varying,
    bulletin_closed_at timestamp without time zone,
    discarded_at timestamp without time zone,
    company_id bigint,
    enable_dark_mode boolean,
    score_30_days bigint DEFAULT 0,
    score_all_time bigint DEFAULT 0,
    score_90_days bigint DEFAULT 0,
    dashboard_fields jsonb,
    dashboard_image integer,
    session_token character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vault_passwords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vault_passwords (
    id bigint NOT NULL,
    name character varying,
    encrypted_password character varying,
    encrypted_password_iv character varying,
    url character varying,
    notes character varying,
    username character varying,
    favorite character varying,
    user_id bigint,
    account_id bigint NOT NULL,
    shared_with_team boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying
);


ALTER TABLE public.vault_passwords OWNER TO postgres;

--
-- Name: vault_passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vault_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vault_passwords_id_seq OWNER TO postgres;

--
-- Name: vault_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vault_passwords_id_seq OWNED BY public.vault_passwords.id;


--
-- Name: website_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.website_histories (
    id bigint NOT NULL,
    website_id bigint NOT NULL,
    code integer,
    up boolean,
    message character varying,
    iteration integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.website_histories OWNER TO postgres;

--
-- Name: website_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.website_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.website_histories_id_seq OWNER TO postgres;

--
-- Name: website_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.website_histories_id_seq OWNED BY public.website_histories.id;


--
-- Name: websites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.websites (
    id bigint NOT NULL,
    name character varying,
    code integer,
    message character varying,
    slug character varying,
    keyword character varying,
    monitor_type integer DEFAULT 0,
    status integer DEFAULT 0,
    monitoring_status integer DEFAULT 0,
    refreshed_at timestamp without time zone,
    monitored_at timestamp without time zone,
    headers jsonb,
    paused boolean DEFAULT false,
    sent_notifications boolean DEFAULT false,
    account_id bigint NOT NULL,
    asset_field_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company_id bigint,
    discarded_at timestamp without time zone,
    disable_ssl boolean DEFAULT false,
    disable_whois boolean DEFAULT false,
    disable_dns boolean DEFAULT false,
    notes text
);


ALTER TABLE public.websites OWNER TO postgres;

--
-- Name: websites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.websites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.websites_id_seq OWNER TO postgres;

--
-- Name: websites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.websites_id_seq OWNED BY public.websites.id;


--
-- Name: whois_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.whois_details (
    id bigint NOT NULL,
    website_id bigint NOT NULL,
    registrar character varying,
    status character varying,
    created timestamp without time zone,
    expires timestamp without time zone,
    updated timestamp without time zone,
    available boolean DEFAULT true,
    contacts jsonb,
    raw text,
    nameservers jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    last_check_code character varying,
    last_check_error boolean,
    last_checked_at timestamp without time zone
);


ALTER TABLE public.whois_details OWNER TO postgres;

--
-- Name: whois_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.whois_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.whois_details_id_seq OWNER TO postgres;

--
-- Name: whois_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.whois_details_id_seq OWNED BY public.whois_details.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: agreements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agreements ALTER COLUMN id SET DEFAULT nextval('public.agreements_id_seq'::regclass);


--
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: asset_fields id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_fields ALTER COLUMN id SET DEFAULT nextval('public.asset_fields_id_seq'::regclass);


--
-- Name: asset_layout_fields id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layout_fields ALTER COLUMN id SET DEFAULT nextval('public.asset_layout_fields_id_seq'::regclass);


--
-- Name: asset_layouts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layouts ALTER COLUMN id SET DEFAULT nextval('public.asset_layouts_id_seq'::regclass);


--
-- Name: asset_passwords id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_passwords ALTER COLUMN id SET DEFAULT nextval('public.asset_passwords_id_seq'::regclass);


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: autotask_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autotask_products ALTER COLUMN id SET DEFAULT nextval('public.autotask_products_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: company_article_templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_article_templates ALTER COLUMN id SET DEFAULT nextval('public.company_article_templates_id_seq'::regclass);


--
-- Name: company_variables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_variables ALTER COLUMN id SET DEFAULT nextval('public.company_variables_id_seq'::regclass);


--
-- Name: configuration_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration_types ALTER COLUMN id SET DEFAULT nextval('public.configuration_types_id_seq'::regclass);


--
-- Name: custom_fast_facts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_fast_facts ALTER COLUMN id SET DEFAULT nextval('public.custom_fast_facts_id_seq'::regclass);


--
-- Name: dns_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dns_details ALTER COLUMN id SET DEFAULT nextval('public.dns_details_id_seq'::regclass);


--
-- Name: domain_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domain_histories ALTER COLUMN id SET DEFAULT nextval('public.domain_histories_id_seq'::regclass);


--
-- Name: domains id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains ALTER COLUMN id SET DEFAULT nextval('public.domains_id_seq'::regclass);


--
-- Name: dynamic_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dynamic_jobs ALTER COLUMN id SET DEFAULT nextval('public.dynamic_jobs_id_seq'::regclass);


--
-- Name: expirations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expirations ALTER COLUMN id SET DEFAULT nextval('public.expirations_id_seq'::regclass);


--
-- Name: export_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.export_items ALTER COLUMN id SET DEFAULT nextval('public.export_items_id_seq'::regclass);


--
-- Name: exports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exports ALTER COLUMN id SET DEFAULT nextval('public.exports_id_seq'::regclass);


--
-- Name: flag_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flag_types ALTER COLUMN id SET DEFAULT nextval('public.flag_types_id_seq'::regclass);


--
-- Name: flags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flags ALTER COLUMN id SET DEFAULT nextval('public.flags_id_seq'::regclass);


--
-- Name: folders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folders ALTER COLUMN id SET DEFAULT nextval('public.folders_id_seq'::regclass);


--
-- Name: gold_standards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gold_standards ALTER COLUMN id SET DEFAULT nextval('public.gold_standards_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: hits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hits ALTER COLUMN id SET DEFAULT nextval('public.hits_id_seq'::regclass);


--
-- Name: imported_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imported_records ALTER COLUMN id SET DEFAULT nextval('public.imported_records_id_seq'::regclass);


--
-- Name: imports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imports ALTER COLUMN id SET DEFAULT nextval('public.imports_id_seq'::regclass);


--
-- Name: integrator_cards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrator_cards ALTER COLUMN id SET DEFAULT nextval('public.integrator_cards_id_seq'::regclass);


--
-- Name: integrators id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrators ALTER COLUMN id SET DEFAULT nextval('public.integrators_id_seq'::regclass);


--
-- Name: invitations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations ALTER COLUMN id SET DEFAULT nextval('public.invitations_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: matchers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchers ALTER COLUMN id SET DEFAULT nextval('public.matchers_id_seq'::regclass);


--
-- Name: password_folders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_folders ALTER COLUMN id SET DEFAULT nextval('public.password_folders_id_seq'::regclass);


--
-- Name: password_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_requests ALTER COLUMN id SET DEFAULT nextval('public.password_requests_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos ALTER COLUMN id SET DEFAULT nextval('public.photos_id_seq'::regclass);


--
-- Name: pins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pins ALTER COLUMN id SET DEFAULT nextval('public.pins_id_seq'::regclass);


--
-- Name: portal_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portal_items ALTER COLUMN id SET DEFAULT nextval('public.portal_items_id_seq'::regclass);


--
-- Name: portal_links id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portal_links ALTER COLUMN id SET DEFAULT nextval('public.portal_links_id_seq'::regclass);


--
-- Name: portals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portals ALTER COLUMN id SET DEFAULT nextval('public.portals_id_seq'::regclass);


--
-- Name: procedure_tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_tasks ALTER COLUMN id SET DEFAULT nextval('public.procedure_tasks_id_seq'::regclass);


--
-- Name: procedures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedures ALTER COLUMN id SET DEFAULT nextval('public.procedures_id_seq'::regclass);


--
-- Name: public_photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_photos ALTER COLUMN id SET DEFAULT nextval('public.public_photos_id_seq'::regclass);


--
-- Name: pwned_passwords id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pwned_passwords ALTER COLUMN id SET DEFAULT nextval('public.pwned_passwords_id_seq'::regclass);


--
-- Name: recordings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recordings ALTER COLUMN id SET DEFAULT nextval('public.recordings_id_seq'::regclass);


--
-- Name: relations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations ALTER COLUMN id SET DEFAULT nextval('public.relations_id_seq'::regclass);


--
-- Name: restrictions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restrictions ALTER COLUMN id SET DEFAULT nextval('public.restrictions_id_seq'::regclass);


--
-- Name: rules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules ALTER COLUMN id SET DEFAULT nextval('public.rules_id_seq'::regclass);


--
-- Name: secure_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secure_notes ALTER COLUMN id SET DEFAULT nextval('public.secure_notes_id_seq'::regclass);


--
-- Name: shares id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shares ALTER COLUMN id SET DEFAULT nextval('public.shares_id_seq'::regclass);


--
-- Name: sidebar_folders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sidebar_folders ALTER COLUMN id SET DEFAULT nextval('public.sidebar_folders_id_seq'::regclass);


--
-- Name: ssl_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssl_details ALTER COLUMN id SET DEFAULT nextval('public.ssl_details_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: uploads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploads ALTER COLUMN id SET DEFAULT nextval('public.uploads_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vault_passwords id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vault_passwords ALTER COLUMN id SET DEFAULT nextval('public.vault_passwords_id_seq'::regclass);


--
-- Name: website_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.website_histories ALTER COLUMN id SET DEFAULT nextval('public.website_histories_id_seq'::regclass);


--
-- Name: websites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.websites ALTER COLUMN id SET DEFAULT nextval('public.websites_id_seq'::regclass);


--
-- Name: whois_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whois_details ALTER COLUMN id SET DEFAULT nextval('public.whois_details_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (id, name, stripe_customer_id, stripe_subscription_id, billing_successful, two_factor_auth_enforced, settings, slug, color, created_at, updated_at, idle_timeout, logo_data, theme, bulletin, bulletin_updated_at, billing_type, custom_css, licensing_key, licensing_plan, saml_issuer_url, saml_login_endpoint, saml_logout_endpoint, saml_fingerprint, saml_certificate, saml_enabled, saml_disable_password_access, shared_logo_data, saml_arn, disable_sharing, favicon_data, authentication_logo_data, score_last_updated, default_password_length, default_time_zone, completed_process_instances, completed_process_instances_last_updated) FROM stdin;
1	Digital Technology Partners	\N	\N	t	f	{"exports": [], "duo_enable": false, "pdf_watermark": "", "primary_color": "#003E6B", "start_of_week": 0, "developer_mode": false, "pdf_disclaimer": "", "portal_kb_name": "Knowledge Base", "structure_name": 0, "portal_pin_name": "Important", "primaryl1_color": "#4098D7", "primaryl2_color": "#84C5F4", "primarys1_color": "#003052", "primarys2_color": "#001829", "saml_use_sha256": false, "sign_in_message": "Sign In", "portal_info_name": "Info", "portal_menu_name": "Menu", "portal_view_name": "View", "portal_close_name": "Close", "portal_files_name": "Files", "portal_links_name": "Links", "smtp_use_override": false, "liongard_num_alerts": 0, "portal_powered_name": "", "portal_download_name": "Download", "portal_overview_name": "Overview", "portal_password_name": "Password", "portal_sign_out_name": "Sign Out", "portal_view_all_name": "View All", "portal_websites_name": "Websites", "portal_passwords_name": "Passwords", "sign_in_message_admin": "Admin Sign In", "sign_in_message_portal": "Portal Sign In", "smtp_start_tls_override": false, "portal_edit_profile_name": "Edit Profile", "portal_password_url_name": "URL", "portal_active_assets_name": "Active Assets", "portal_password_copy_name": "Copy", "portal_active_folders_name": "Active Folders", "portal_password_notes_name": "Notes", "portal_active_websites_name": "Active Websites", "portal_password_copied_name": "Copied", "portal_password_reveal_name": "Reveal", "portal_active_passwords_name": "Active Passwords", "portal_password_changed_name": "Last Changed", "portal_password_username_name": "Username", "show_otp_secrets_when_editing": false, "portal_password_easy_read_name": "Easy Read"}	\N	\N	2023-01-19 17:36:44.402746	2023-01-26 12:00:00.273306	\N	\N	0	\N	\N	0	\N	HUDU-EV0S-WDD9-QDRS-4ZC1	self_hosted	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	UTC	[0, 0]	2023-01-26 12:00:00.272042
\.


--
-- Data for Name: agreements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.agreements (id, company_id, sync_identifier, contact_name, start_date, end_date, cancelled_date, agreement_type, cancelled_flag, no_end_date_flag, cancel_reason, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerts (id, account_id, email, name, alert_type, expiration_type, days_until, created_at, updated_at, webhook_payload, webhook_url, stop_on_trigger, include_archived_records, company_id) FROM stdin;
\.


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_keys (id, account_id, name, token, created_at, updated_at, password_access, destructive_actions, allowed_ips, company_id) FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2023-01-19 16:46:17.971694	2023-01-19 16:46:17.971694
schema_sha1	4eb84f2bcf64538c6373c9007dbd68461e9c8cc9	2023-01-19 16:46:17.97633	2023-01-19 16:46:17.97633
\.


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articles (id, account_id, name, slug, content, discarded_at, created_at, updated_at, public_token, is_template, company_id, enable_sharing, folder_id, draft, draft_title, draft_content, draft_autosaved_at, draft_folder_id, read_only, article_template, article_template_id, is_upload) FROM stdin;
\.


--
-- Data for Name: asset_fields; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_fields (id, asset_layout_field_id, asset_id, string_value, boolean_value, date_value, text_value, encrypted_password_value, encrypted_password_value_iv, integer_value, type, linkable_type, linkable_id, domain_id, created_at, updated_at, password_updated_at, data) FROM stdin;
\.


--
-- Data for Name: asset_layout_fields; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_layout_fields (id, asset_layout_id, min, max, required, "position", label, hint, type, expiration, options, linkable_type, linkable_id, created_at, updated_at, is_destroyed, show_in_list) FROM stdin;
\.


--
-- Data for Name: asset_layouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_layouts (id, name, slug, synced, synced_name, color, icon_color, icon, include_passwords, include_files, account_id, created_at, updated_at, active, field_names, include_comments, password_types, integrator_id, include_processes, description, include_photos, alternate_name, sidebar_folder_id, name_list) FROM stdin;
\.


--
-- Data for Name: asset_passwords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_passwords (id, encrypted_password, encrypted_password_iv, description, name, asset_id, discarded_at, created_at, updated_at, company_id, account_id, username, password_type, url, slug, password_updated_at, passwordable_id, passwordable_type, in_portal, encrypted_otp_secret, encrypted_otp_secret_iv, color, password_folder_id) FROM stdin;
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assets (id, company_id, asset_layout_id, slug, name, discarded_at, discarded_by_integration, created_at, updated_at, integration_fields, synced, sync_status, last_synced, sync_id, sync_type, last_sync_message, integrator_type, integrator_id, primary_mail, primary_serial, primary_manufacturer, primary_model, primary_mac) FROM stdin;
\.


--
-- Data for Name: autotask_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autotask_products (id, integrator_id, autotask_id, product_name, product_manufacturer, product_model, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, account, commentable_type, commentable_id, user_id, editing_user_id, body, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (id, slug, name, nickname, address_line_1, address_line_2, city, state, zip, country_name, phone_number, fax_number, website, notes, integration_fields, discarded_by_integration, synced, sync_status, last_synced, sync_id, discarded_at, account_id, created_at, updated_at, last_sync_message, identifier, rating, logo_data, office_licensing, parent_company_id, id_number, company_type, lat, lon, address_changed) FROM stdin;
\.


--
-- Data for Name: company_article_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company_article_templates (id, article_id, company_id, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: company_variables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company_variables (id, key, value, company_id, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: configuration_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuration_types (id, integrator_id, name, type_id, skipped, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: custom_fast_facts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.custom_fast_facts (id, company_id, title, message, content, shade, icon, image_url, content_link, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dns_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dns_details (id, website_id, a, mx, txt, aaaa, ns, soa, ptr, created_at, updated_at, last_check_code, last_check_error, last_checked_at) FROM stdin;
\.


--
-- Data for Name: domain_histories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domain_histories (id, domain_id, down_at, up_at, checked_status, created_at, updated_at, status_code) FROM stdin;
\.


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domains (id, checked_status, info_status, account_id, name, last_checked, company_id, a_records, mx_records, txt_records, aaaa_records, ns_records, soa_records, ptr_records, whois_registrar, whois_status, whois_created, whois_expires, whois_updated, whois_available, whois_contacts, whois_raw, whois_nameservers, last_refresh_at, created_at, updated_at, sent_notifications, certificate, ssl_invalid_error, not_before, not_after, public_key, version, subject, serial, issuer, signature_algorithm, ssl_valid, pause_monitoring) FROM stdin;
\.


--
-- Data for Name: dynamic_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dynamic_jobs (id, account_id, next_run_at, klass, cron_expression, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: expirations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expirations (id, date, expirationable_type, expirationable_id, account_id, company_id, asset_layout_field_id, sync_id, discarded_at, created_at, updated_at, expiration_type, asset_field_id) FROM stdin;
\.


--
-- Data for Name: export_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.export_items (id, account_id, export_id, filename, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: exports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exports (id, account_id, s3_bucket, s3_public, s3_private, s3_region, status, created_at, updated_at, file_data, is_pdf, mask_passwords) FROM stdin;
\.


--
-- Data for Name: flag_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flag_types (id, name, color, slug, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flags (id, flag_type_id, user_id, account_id, active, description, flagable_type, flagable_id, created_at, updated_at, company_id) FROM stdin;
\.


--
-- Data for Name: folders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.folders (id, account_id, name, icon, company_id, ancestry, created_at, updated_at, description) FROM stdin;
\.


--
-- Data for Name: gold_standards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gold_standards (id, standardable_type, standardable_id, asset_layout_id, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, account_id, name, slug, use_schedule, access_start, access_end, time_zone, monday_login, tuesday_login, wednesday_login, thursday_login, friday_login, saturday_login, sunday_login, created_at, updated_at, remove_global_kb_access, remove_personal_vault_access, remove_access_to_passwords, remove_access_to_otp_secrets, create_client_dashboard_view, remove_share_ability, switch_to_allow_list, denied_asset_layout_ids, remove_agreements, "default") FROM stdin;
\.


--
-- Data for Name: hits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hits (id, count, user_id, account_id, hitable_type, hitable_id, created_at, updated_at, company_id) FROM stdin;
1	2	3	1	User	3	2023-01-20 16:50:08.49174	2023-01-20 16:50:08.49174	\N
2	3	1	1	User	1	2023-01-23 15:37:04.080756	2023-01-23 15:37:04.080756	\N
\.


--
-- Data for Name: imported_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imported_records (id, import_id, imported_recordable_type, imported_recordable_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: imports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imports (id, account_id, matching, data, import_type, status, created_at, updated_at, asset_layout_id, asset_layout_name) FROM stdin;
\.


--
-- Data for Name: integrator_cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.integrator_cards (id, integrator_id, asset_id, sync_type, sync_id, last_synced, sync_status, data, created_at, updated_at, sync_identifier, primary_mail, report_refresh_date, is_deleted, deleted_date, has_exchange_license, has_onedrive_license, has_sharepoint_license, has_skype_for_business_license, has_yammer_license, has_teams_license, exchange_last_activity_date, onedrive_last_activity_date, sharepoint_last_activity_date, skype_for_business_last_activity_date, yammer_last_activity_date, teams_last_activity_date, exchange_license_assign_date, onedrive_license_assign_date, sharepoint_license_assign_date, skype_for_business_license_assign_date, yammer_license_assign_date, teams_license_assign_date, storage_used_byte, issue_warning_quota_byte, prohibit_send_quota_byte, prohibit_send_receive_quota_byte, assigned_products, primary_serial, primary_model, primary_manufacturer, primary_mac, primary_phone, important_contact) FROM stdin;
\.


--
-- Data for Name: integrators; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.integrators (id, account_id, integration_slug, active, last_synced_at, password, key, api_domain, api_company, created_at, updated_at, next_run_at, configuration_types, settings, mapped_layout_1, mapped_layout_2, mapped_layout_3, mapped_layout_4, mapped_layout_5, status, company_id) FROM stdin;
\.


--
-- Data for Name: invitations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invitations (id, user_id, token, activated, created_at, updated_at) FROM stdin;
1	2	V8fDdvPhYTVT8kaEbDvAeuMX	f	2023-01-19 17:44:33.449642	2023-01-19 17:44:33.449642
2	3	aJjpfk5r1WvWiJng4rqHo831	t	2023-01-19 17:44:33.469243	2023-01-19 18:00:16.579809
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, account_id, message, logable_type, logable_id, record_type, record_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: matchers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matchers (id, account_id, integrator_id, company_id, potential_company_id, sync_id, name, created_at, updated_at, identifier) FROM stdin;
\.


--
-- Data for Name: password_folders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_folders (id, name, security, add_to_portal, description, slug, created_at, updated_at, allowed_groups, company_id) FROM stdin;
\.


--
-- Data for Name: password_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_requests (id, user_id, portal_id, requestable_type, requestable_id, description, discarded_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pg_search_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pg_search_documents (id, content, company_id, discarded_at, searchable_type, searchable_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.photos (id, photoable_type, photoable_id, account_id, file_data, caption, discarded_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pins (id, pinable_type, pinable_id, user_id, created_at, updated_at, "position") FROM stdin;
\.


--
-- Data for Name: portal_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.portal_items (id, portal_id, portalable_type, portalable_id, asset_layout_id, pin, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: portal_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.portal_links (id, name, url, new_tab, description, portal_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: portals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.portals (id, company_id, active, layout, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: procedure_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procedure_tasks (id, procedure_id, name, description, "position", completed, user_id, completed_at, created_at, updated_at, completion_notes) FROM stdin;
\.


--
-- Data for Name: procedures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procedures (id, name, slug, description, discarded_at, template, company_id, account_id, created_at, updated_at, asset_id, parent_procedure_id, share_token, global_template_id, remove_completion_ability, featured, autofeatured) FROM stdin;
\.


--
-- Data for Name: public_photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_photos (id, image_first_url, image_data, created_at, updated_at, record_type, record_id) FROM stdin;
\.


--
-- Data for Name: pwned_passwords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pwned_passwords (id, count, pwned, company_id, account_id, asset_password_id, created_at, updated_at, asset_field_id) FROM stdin;
\.


--
-- Data for Name: recordings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recordings (id, details, integration_fields, action, longitude, latitude, address, city, state, state_code, postal_code, country, country_code, user_agent, ip_address, token, user_id, account_id, company_id, recordingable_type, recordingable_id, created_at, updated_at, old_name, app_type) FROM stdin;
1	{}	{}	created	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.55	24.98.5.218	XEn1ySsS1WneZ8aaBP4W8HV9	1	1	\N	User	2	2023-01-19 17:44:33.437077	2023-01-19 17:44:33.437077	\N	0
2	{}	{}	created	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.55	24.98.5.218	17Kp3LGg3NcwM56mmHze1PQU	1	1	\N	User	3	2023-01-19 17:44:33.465915	2023-01-19 17:44:33.465915	\N	0
3	{}	{}	signed in	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.52	172.75.186.64	KsFcdmei1ZjWoxhUnzqvUH5M	3	1	\N	User	3	2023-01-20 16:50:08.496383	2023-01-20 16:50:08.496383	\N	0
4	{}	{}	signed in	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	cpfmE8mfN22GuPPtXDb1JgcE	1	1	\N	User	1	2023-01-23 15:37:04.084754	2023-01-23 15:37:04.084754	\N	0
6	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	L3jZuUPDWZa4E12m5NEuaLRA	1	1	\N	Company	1	2023-01-23 15:45:29.825664	2023-01-23 15:45:29.825664	\N	0
7	{}	{}	signed in	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	172.75.186.64	cbTGXpFasz4uNiqYNUe8BTJR	3	1	\N	User	3	2023-01-25 13:32:08.190305	2023-01-25 13:32:08.190305	\N	0
8	{}	{}	signed in	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	RmKU3gn176XVLN9JdtJcGvE7	1	1	\N	User	1	2023-01-25 20:34:15.611125	2023-01-25 20:34:15.611125	\N	0
9	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	kwzzqEFXAje7LC63ddN6PSM9	1	1	\N	Company	1	2023-01-25 20:34:43.457194	2023-01-25 20:34:43.457194	\N	0
10	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	8A3Z5dCfKbuvtctqTNAEgYgi	1	1	\N	Company	1	2023-01-25 20:44:25.921885	2023-01-25 20:44:25.921885	\N	0
24	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	7zrYwh5S2gjUENfbujfwHTeM	1	1	\N	Company	1	2023-01-25 20:48:06.171601	2023-01-25 20:48:06.171601	\N	0
30	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	Gn6SCj2MNyKD1TErXNFX3U32	1	1	\N	Company	1	2023-01-25 20:48:37.284262	2023-01-25 20:48:37.284262	\N	0
31	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	atPkGKtXhHiSH9qpC4x5n1iy	1	1	\N	Company	1	2023-01-25 20:49:30.534804	2023-01-25 20:49:30.534804	\N	0
53	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	b3dijapx2aDjn865aX4Cctnp	1	1	\N	Company	1	2023-01-25 20:50:54.463566	2023-01-25 20:50:54.463566	\N	0
69	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	PZVfKxirwfNrWdv8iYXVT2sK	1	1	\N	Company	1	2023-01-25 20:56:15.233005	2023-01-25 20:56:15.233005	\N	0
70	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	4dXAaxLWN7tBW9d3Ahaffw5V	1	1	\N	Company	1	2023-01-25 20:57:07.032021	2023-01-25 20:57:07.032021	\N	0
75	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	sgV2pu7uPkavZoxajoBa7Vnn	1	1	\N	Company	1	2023-01-25 21:04:48.030742	2023-01-25 21:04:48.030742	\N	0
120	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	pLoWtLHLT9yi7CRFDE1Qsb52	1	1	\N	Company	1	2023-01-25 21:08:05.559847	2023-01-25 21:08:05.559847	\N	0
124	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	FUU7LD79pMxPoRxR3gWGDXgj	1	1	\N	Company	1	2023-01-25 21:17:01.426015	2023-01-25 21:17:01.426015	\N	0
125	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	kQKuUZTN2UBPkpNd1nzxVLiW	1	1	\N	Company	1	2023-01-25 21:19:02.939523	2023-01-25 21:19:02.939523	\N	0
130	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	xUtj9toyfVUddxF6vzRvTkFD	1	1	\N	Company	1	2023-01-25 21:20:14.807938	2023-01-25 21:20:14.807938	\N	0
131	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	172.75.186.64	hy3Wxn3qGxkeSBYWetw6ywqp	3	1	\N	Company	1	2023-01-25 22:00:10.055734	2023-01-25 22:00:10.055734	\N	0
136	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	172.75.186.64	vKwLnTbpHcPp6yoiCXsB8sTc	3	1	\N	Company	1	2023-01-25 22:01:03.368769	2023-01-25 22:01:03.368769	\N	0
138	{}	{}	signed in	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	vw49fTvWBNX42Vjg86W4GL7V	1	1	\N	User	1	2023-01-26 13:00:51.150398	2023-01-26 13:00:51.150398	\N	0
139	{}	{}	viewed	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61	24.98.5.218	aWnQ7sdquHsqA5T2gKoeEDmG	1	1	\N	Company	1	2023-01-26 13:01:01.103799	2023-01-26 13:01:01.103799	\N	0
\.


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relations (id, description, fromable_type, fromable_id, toable_type, toable_id, is_inverse, created_at, updated_at, account_id) FROM stdin;
\.


--
-- Data for Name: restrictions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restrictions (id, group_id, restricted, restrictable_type, restrictable_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rules (id, integrator_id, configuration_type_id, asset_layout_id, created_at, updated_at, new_asset_layout_name) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20221208190223
20180109091909
20180109175032
20180109175033
20180109175034
20180112174959
20180423050654
20180529214543
20180606164621
20180619170826
20180711054230
20180731202610
20180806162301
20180809170800
20181016172148
20181211074300
20181211074357
20181221075804
20190103045059
20190109070050
20190228190123
20190308183646
20190609030641
20190609030946
20190614205227
20190621222706
20190622074055
20190624143938
20190626050100
20190626060937
20190626201846
20190626202903
20190626203019
20190627182451
20190627225927
20190628162140
20190628162258
20190701142925
20190704144510
20190704152727
20190704153219
20190705191001
20190706172745
20190707040539
20190708164724
20190710210208
20190710221227
20190711010824
20190711202945
20190711203412
20190711225252
20190711225458
20190711225618
20190712033443
20190714105308
20190717180824
20190717184231
20190718040646
20190718191004
20190719013400
20190719041248
20190719041841
20190719220915
20190720043623
20190721171041
20190722002416
20190724165320
20190724194455
20190725022838
20190725035843
20190725054244
20190725055732
20190725060239
20190729174805
20190731014827
20190731023400
20190731150047
20190731180735
20190808221719
20190809171518
20190809174409
20190810233139
20190815174930
20190815230039
20190816025634
20190817035110
20190823204019
20190824003041
20190826205356
20190826210815
20190928052405
20190928053659
20190929220037
20190930012034
20191004185103
20191006220250
20191022155842
20191024040612
20191025155110
20191117234429
20191118013049
20191201013724
20191201184804
20191206234828
20191217064223
20191217170644
20191218213508
20191220001004
20191223231032
20191223231848
20191229220417
20200105045023
20200114061913
20200114200151
20200121194154
20200122230508
20200123173843
20200127214712
20200205001608
20200208053847
20200210211707
20200211024145
20200211060712
20200213174230
20200216222314
20200216231235
20200218000145
20200221015408
20200222055841
20200222234837
20200226180809
20200226222439
20200228013623
20200229185858
20200302061019
20200306205046
20200306205909
20200307022930
20200315184010
20200318041834
20200318052455
20200319225713
20200321171750
20200323175411
20200325023453
20200326172250
20200402225404
20200405195810
20200406005531
20200419212053
20200427234008
20200513170526
20200524171227
20200531181935
20200610000347
20200612164814
20200630175900
20200718162419
20200721212656
20200725171354
20200726063953
20200814160832
20200815175103
20200816005844
20200820182015
20200825173623
20200910163601
20200917152329
20201008040947
20201122214553
20201124155536
20201125053011
20201205044404
20201220004802
20201220233736
20201220234351
20201228170006
20201228170214
20210101232447
20210115221227
20210212174952
20210415211056
20210516175834
20210524215014
20210524225217
20210526010150
20210527220135
20210601215305
20210615172929
20210630160102
20210702162129
20210714215441
20210731003024
20210731172230
20210819204743
20211011155443
20211105165238
20211107180656
20211214032651
20220306225753
20220308172821
20220311012457
20220415180040
20220418160618
20220418181557
20220507001814
20220509202847
20220517140309
20220517151023
20220517152725
20220528034835
20220719210226
20220810043905
20220815185924
20220815190806
20220815224147
\.


--
-- Data for Name: secure_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.secure_notes (id, note, expiration_date, company_id, first_view, label, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shares (id, shareable_type, shareable_id, notes, token, expire_in, include_passwords, include_files, created_at, updated_at, one_time_expire, include_username, include_otp, include_url) FROM stdin;
\.


--
-- Data for Name: sidebar_folders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sidebar_folders (id, icon, name, color, icon_color, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ssl_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ssl_details (id, website_id, certificate, certificate_valid, invalid_error, not_before, not_after, public_key, version, subject, serial, issuer, signature_algorithm, created_at, updated_at, last_check_code, last_check_error, last_checked_at) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, name, company_id, tagable_type, tagable_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uploads (id, file_data, uploadable_type, uploadable_id, account_id, created_at, updated_at, discarded_at, name) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, encrypted_password, encrypted_otp_secret, encrypted_otp_secret_iv, encrypted_otp_secret_salt, otp_backup_codes, consumed_timestep, otp_required_for_login, employee, unconfirmed_otp_secret, security_level, first_name, last_name, phone_number, random_number_for_avatar, slug, time_zone, accepted_invite, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, account_id, group_id, settings, created_at, updated_at, avatar_data, bulletin_closed_at, discarded_at, company_id, enable_dark_mode, score_30_days, score_all_time, score_90_days, dashboard_fields, dashboard_image, session_token) FROM stdin;
2	travis.grillot@dtpartners.com		\N	\N	\N	\N	\N	f	f	\N	2	Invited	User	\N	8	invited-user-b127185289c5	UTC	f	\N	\N	\N	0	\N	\N	\N	\N	1	\N	{"military_time": false, "closed_learning": false, "company_quick_hop": false, "notifications_expiration_trigger_time": 14}	2023-01-19 17:44:33.433946	2023-01-19 17:44:33.433946	\N	\N	\N	\N	\N	0	0	0	\N	\N	\N
3	eric.jones@dtpartners.com	$2a$11$VY4aB8CTx37nX5sV3JzQq.e5e3zMfJOtqGQv/w1MqTqOZCUpuxJ6u	ZvqZZ7TsJSB73JAGd/8bPcmP53sbDMw82BpBBJPpsIBz2X12NylgYg==\n	8y/lc8/vbzD8Kszh\n	_NpdweD0DCKlXBzUfqLpDIQ==\n	\N	55821793	t	f	\N	2	Eric	Jones	\N	4	invited-user-bc7b5c487740	UTC	f	\N	\N	\N	3	2023-01-25 13:32:08.048465	2023-01-20 16:50:08.359102	172.75.186.64	172.75.186.64	1	\N	{"theme": "pitkin", "military_time": false, "closed_learning": true, "company_quick_hop": false, "notifications_expiration_trigger_time": 14}	2023-01-19 17:44:33.463695	2023-01-25 21:59:36.784217	{"original":{"id":"user/3/avatar/original-c1a7296094171235233a147968d1c3ce.png","storage":"store","metadata":{"filename":"phoebe2.png","size":352029,"mime_type":"image/png","width":446,"height":466}},"small":{"id":"user/3/avatar/small-79f2e21d49e681b73307a8bdd65d4cbe.png","storage":"store","metadata":{"filename":"image_processing20230125-1-11n7o6v.png","size":3056,"mime_type":"image/png","width":31,"height":32}}}	\N	\N	\N	t	0	0	0	\N	\N	722038391466010701a960e7ec0628be
1	levi@dtpartners.com	$2a$11$QAnblUitwGVF9JqlPzl.o.zHWVH.VOAcRdmlhKq/3fIotmAOb90hW	\N	\N	\N	\N	\N	f	f	\N	3	Levi	Shores	\N	7	levi-shores-04b8a7fe2d3f	UTC	f	\N	\N	\N	4	2023-01-26 13:00:51.014324	2023-01-25 20:34:15.481775	24.98.5.218	24.98.5.218	1	\N	{"military_time": false, "closed_learning": true, "company_quick_hop": false, "notifications_expiration_trigger_time": 14}	2023-01-19 17:36:44.407106	2023-01-26 13:00:51.014913	\N	\N	\N	\N	t	0	0	0	\N	\N	2867616cc5c56d54cd7add363ca95c70
\.


--
-- Data for Name: vault_passwords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vault_passwords (id, name, encrypted_password, encrypted_password_iv, url, notes, username, favorite, user_id, account_id, shared_with_team, created_at, updated_at, encrypted_otp_secret, encrypted_otp_secret_iv) FROM stdin;
\.


--
-- Data for Name: website_histories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.website_histories (id, website_id, code, up, message, iteration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: websites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.websites (id, name, code, message, slug, keyword, monitor_type, status, monitoring_status, refreshed_at, monitored_at, headers, paused, sent_notifications, account_id, asset_field_id, created_at, updated_at, company_id, discarded_at, disable_ssl, disable_whois, disable_dns, notes) FROM stdin;
\.


--
-- Data for Name: whois_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.whois_details (id, website_id, registrar, status, created, expires, updated, available, contacts, raw, nameservers, created_at, updated_at, last_check_code, last_check_error, last_checked_at) FROM stdin;
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_id_seq', 1, true);


--
-- Name: agreements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.agreements_id_seq', 1, false);


--
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq', 1, false);


--
-- Name: api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_keys_id_seq', 1, false);


--
-- Name: articles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articles_id_seq', 1, false);


--
-- Name: asset_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_fields_id_seq', 45, true);


--
-- Name: asset_layout_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_layout_fields_id_seq', 38, true);


--
-- Name: asset_layouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_layouts_id_seq', 7, true);


--
-- Name: asset_passwords_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_passwords_id_seq', 3, true);


--
-- Name: assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assets_id_seq', 6, true);


--
-- Name: autotask_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autotask_products_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.companies_id_seq', 1, true);


--
-- Name: company_article_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_article_templates_id_seq', 1, false);


--
-- Name: company_variables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_variables_id_seq', 1, false);


--
-- Name: configuration_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configuration_types_id_seq', 1, false);


--
-- Name: custom_fast_facts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.custom_fast_facts_id_seq', 1, false);


--
-- Name: dns_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dns_details_id_seq', 1, false);


--
-- Name: domain_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.domain_histories_id_seq', 1, false);


--
-- Name: domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.domains_id_seq', 1, false);


--
-- Name: dynamic_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dynamic_jobs_id_seq', 1, false);


--
-- Name: expirations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expirations_id_seq', 1, false);


--
-- Name: export_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.export_items_id_seq', 1, false);


--
-- Name: exports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exports_id_seq', 1, false);


--
-- Name: flag_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flag_types_id_seq', 1, false);


--
-- Name: flags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flags_id_seq', 1, false);


--
-- Name: folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.folders_id_seq', 1, false);


--
-- Name: gold_standards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gold_standards_id_seq', 1, false);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 1, false);


--
-- Name: hits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hits_id_seq', 15, true);


--
-- Name: imported_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imported_records_id_seq', 1, false);


--
-- Name: imports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imports_id_seq', 1, false);


--
-- Name: integrator_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.integrator_cards_id_seq', 1, false);


--
-- Name: integrators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.integrators_id_seq', 1, false);


--
-- Name: invitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invitations_id_seq', 2, true);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 1, false);


--
-- Name: matchers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matchers_id_seq', 1, false);


--
-- Name: password_folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_folders_id_seq', 1, false);


--
-- Name: password_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_requests_id_seq', 1, false);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pg_search_documents_id_seq', 1, false);


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.photos_id_seq', 1, false);


--
-- Name: pins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pins_id_seq', 1, false);


--
-- Name: portal_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.portal_items_id_seq', 1, false);


--
-- Name: portal_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.portal_links_id_seq', 1, false);


--
-- Name: portals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.portals_id_seq', 1, false);


--
-- Name: procedure_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.procedure_tasks_id_seq', 1, false);


--
-- Name: procedures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.procedures_id_seq', 1, false);


--
-- Name: public_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_photos_id_seq', 1, false);


--
-- Name: pwned_passwords_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pwned_passwords_id_seq', 3, true);


--
-- Name: recordings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recordings_id_seq', 140, true);


--
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relations_id_seq', 1, false);


--
-- Name: restrictions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restrictions_id_seq', 1, false);


--
-- Name: rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rules_id_seq', 1, false);


--
-- Name: secure_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.secure_notes_id_seq', 1, false);


--
-- Name: shares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shares_id_seq', 1, false);


--
-- Name: sidebar_folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sidebar_folders_id_seq', 2, true);


--
-- Name: ssl_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ssl_details_id_seq', 1, false);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- Name: uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uploads_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: vault_passwords_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vault_passwords_id_seq', 1, false);


--
-- Name: website_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.website_histories_id_seq', 1, false);


--
-- Name: websites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.websites_id_seq', 1, false);


--
-- Name: whois_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.whois_details_id_seq', 1, false);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: agreements agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT agreements_pkey PRIMARY KEY (id);


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: asset_fields asset_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_fields
    ADD CONSTRAINT asset_fields_pkey PRIMARY KEY (id);


--
-- Name: asset_layout_fields asset_layout_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layout_fields
    ADD CONSTRAINT asset_layout_fields_pkey PRIMARY KEY (id);


--
-- Name: asset_layouts asset_layouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layouts
    ADD CONSTRAINT asset_layouts_pkey PRIMARY KEY (id);


--
-- Name: asset_passwords asset_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_passwords
    ADD CONSTRAINT asset_passwords_pkey PRIMARY KEY (id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: autotask_products autotask_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autotask_products
    ADD CONSTRAINT autotask_products_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_article_templates company_article_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_article_templates
    ADD CONSTRAINT company_article_templates_pkey PRIMARY KEY (id);


--
-- Name: company_variables company_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_variables
    ADD CONSTRAINT company_variables_pkey PRIMARY KEY (id);


--
-- Name: configuration_types configuration_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration_types
    ADD CONSTRAINT configuration_types_pkey PRIMARY KEY (id);


--
-- Name: custom_fast_facts custom_fast_facts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_fast_facts
    ADD CONSTRAINT custom_fast_facts_pkey PRIMARY KEY (id);


--
-- Name: dns_details dns_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dns_details
    ADD CONSTRAINT dns_details_pkey PRIMARY KEY (id);


--
-- Name: domain_histories domain_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domain_histories
    ADD CONSTRAINT domain_histories_pkey PRIMARY KEY (id);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: dynamic_jobs dynamic_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dynamic_jobs
    ADD CONSTRAINT dynamic_jobs_pkey PRIMARY KEY (id);


--
-- Name: expirations expirations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expirations
    ADD CONSTRAINT expirations_pkey PRIMARY KEY (id);


--
-- Name: export_items export_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.export_items
    ADD CONSTRAINT export_items_pkey PRIMARY KEY (id);


--
-- Name: exports exports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exports
    ADD CONSTRAINT exports_pkey PRIMARY KEY (id);


--
-- Name: flag_types flag_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flag_types
    ADD CONSTRAINT flag_types_pkey PRIMARY KEY (id);


--
-- Name: flags flags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: folders folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: gold_standards gold_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gold_standards
    ADD CONSTRAINT gold_standards_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: hits hits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hits
    ADD CONSTRAINT hits_pkey PRIMARY KEY (id);


--
-- Name: imported_records imported_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imported_records
    ADD CONSTRAINT imported_records_pkey PRIMARY KEY (id);


--
-- Name: imports imports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);


--
-- Name: integrator_cards integrator_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrator_cards
    ADD CONSTRAINT integrator_cards_pkey PRIMARY KEY (id);


--
-- Name: integrators integrators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrators
    ADD CONSTRAINT integrators_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: matchers matchers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchers
    ADD CONSTRAINT matchers_pkey PRIMARY KEY (id);


--
-- Name: password_folders password_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_folders
    ADD CONSTRAINT password_folders_pkey PRIMARY KEY (id);


--
-- Name: password_requests password_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_requests
    ADD CONSTRAINT password_requests_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: photos photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: pins pins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pins
    ADD CONSTRAINT pins_pkey PRIMARY KEY (id);


--
-- Name: portal_items portal_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portal_items
    ADD CONSTRAINT portal_items_pkey PRIMARY KEY (id);


--
-- Name: portal_links portal_links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portal_links
    ADD CONSTRAINT portal_links_pkey PRIMARY KEY (id);


--
-- Name: portals portals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portals
    ADD CONSTRAINT portals_pkey PRIMARY KEY (id);


--
-- Name: procedure_tasks procedure_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_tasks
    ADD CONSTRAINT procedure_tasks_pkey PRIMARY KEY (id);


--
-- Name: procedures procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT procedures_pkey PRIMARY KEY (id);


--
-- Name: public_photos public_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_photos
    ADD CONSTRAINT public_photos_pkey PRIMARY KEY (id);


--
-- Name: pwned_passwords pwned_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pwned_passwords
    ADD CONSTRAINT pwned_passwords_pkey PRIMARY KEY (id);


--
-- Name: recordings recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT recordings_pkey PRIMARY KEY (id);


--
-- Name: relations relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: restrictions restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restrictions
    ADD CONSTRAINT restrictions_pkey PRIMARY KEY (id);


--
-- Name: rules rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: secure_notes secure_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secure_notes
    ADD CONSTRAINT secure_notes_pkey PRIMARY KEY (id);


--
-- Name: shares shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT shares_pkey PRIMARY KEY (id);


--
-- Name: sidebar_folders sidebar_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sidebar_folders
    ADD CONSTRAINT sidebar_folders_pkey PRIMARY KEY (id);


--
-- Name: ssl_details ssl_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssl_details
    ADD CONSTRAINT ssl_details_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: uploads uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vault_passwords vault_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vault_passwords
    ADD CONSTRAINT vault_passwords_pkey PRIMARY KEY (id);


--
-- Name: website_histories website_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.website_histories
    ADD CONSTRAINT website_histories_pkey PRIMARY KEY (id);


--
-- Name: websites websites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.websites
    ADD CONSTRAINT websites_pkey PRIMARY KEY (id);


--
-- Name: whois_details whois_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whois_details
    ADD CONSTRAINT whois_details_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_settings; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_on_settings ON public.accounts USING gin (settings);


--
-- Name: index_accounts_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_accounts_on_slug ON public.accounts USING btree (slug);


--
-- Name: index_agreements_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_agreements_on_company_id ON public.agreements USING btree (company_id);


--
-- Name: index_alerts_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_alerts_on_account_id ON public.alerts USING btree (account_id);


--
-- Name: index_alerts_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_alerts_on_company_id ON public.alerts USING btree (company_id);


--
-- Name: index_api_keys_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_api_keys_on_account_id ON public.api_keys USING btree (account_id);


--
-- Name: index_api_keys_on_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_api_keys_on_token ON public.api_keys USING btree (token);


--
-- Name: index_articles_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_articles_on_account_id ON public.articles USING btree (account_id);


--
-- Name: index_articles_on_article_template_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_articles_on_article_template_id ON public.articles USING btree (article_template_id);


--
-- Name: index_articles_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_articles_on_company_id ON public.articles USING btree (company_id);


--
-- Name: index_articles_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_articles_on_discarded_at ON public.articles USING btree (discarded_at);


--
-- Name: index_articles_on_folder_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_articles_on_folder_id ON public.articles USING btree (folder_id);


--
-- Name: index_articles_on_public_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_articles_on_public_token ON public.articles USING btree (public_token);


--
-- Name: index_articles_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_articles_on_slug ON public.articles USING btree (slug);


--
-- Name: index_asset_fields_on_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_fields_on_asset_id ON public.asset_fields USING btree (asset_id);


--
-- Name: index_asset_fields_on_asset_layout_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_fields_on_asset_layout_field_id ON public.asset_fields USING btree (asset_layout_field_id);


--
-- Name: index_asset_fields_on_domain_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_fields_on_domain_id ON public.asset_fields USING btree (domain_id);


--
-- Name: index_asset_fields_on_linkable_type_and_linkable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_fields_on_linkable_type_and_linkable_id ON public.asset_fields USING btree (linkable_type, linkable_id);


--
-- Name: index_asset_layout_fields_on_asset_layout_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_layout_fields_on_asset_layout_id ON public.asset_layout_fields USING btree (asset_layout_id);


--
-- Name: index_asset_layout_fields_on_linkable_type_and_linkable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_layout_fields_on_linkable_type_and_linkable_id ON public.asset_layout_fields USING btree (linkable_type, linkable_id);


--
-- Name: index_asset_layouts_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_layouts_on_account_id ON public.asset_layouts USING btree (account_id);


--
-- Name: index_asset_layouts_on_integrator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_layouts_on_integrator_id ON public.asset_layouts USING btree (integrator_id);


--
-- Name: index_asset_layouts_on_sidebar_folder_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_layouts_on_sidebar_folder_id ON public.asset_layouts USING btree (sidebar_folder_id);


--
-- Name: index_asset_layouts_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_asset_layouts_on_slug ON public.asset_layouts USING btree (slug);


--
-- Name: index_asset_layouts_on_synced_name_and_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_asset_layouts_on_synced_name_and_account_id ON public.asset_layouts USING btree (synced_name, account_id);


--
-- Name: index_asset_passwords_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_passwords_on_account_id ON public.asset_passwords USING btree (account_id);


--
-- Name: index_asset_passwords_on_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_passwords_on_asset_id ON public.asset_passwords USING btree (asset_id);


--
-- Name: index_asset_passwords_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_passwords_on_company_id ON public.asset_passwords USING btree (company_id);


--
-- Name: index_asset_passwords_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_passwords_on_discarded_at ON public.asset_passwords USING btree (discarded_at);


--
-- Name: index_asset_passwords_on_password_folder_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_asset_passwords_on_password_folder_id ON public.asset_passwords USING btree (password_folder_id);


--
-- Name: index_assets_on_asset_layout_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_assets_on_asset_layout_id ON public.assets USING btree (asset_layout_id);


--
-- Name: index_assets_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_assets_on_company_id ON public.assets USING btree (company_id);


--
-- Name: index_assets_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_assets_on_discarded_at ON public.assets USING btree (discarded_at);


--
-- Name: index_assets_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_assets_on_slug ON public.assets USING btree (slug);


--
-- Name: index_autotask_products_on_integrator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_autotask_products_on_integrator_id ON public.autotask_products USING btree (integrator_id);


--
-- Name: index_comments_on_commentable_type_and_commentable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_comments_on_commentable_type_and_commentable_id ON public.comments USING btree (commentable_type, commentable_id);


--
-- Name: index_comments_on_editing_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_comments_on_editing_user_id ON public.comments USING btree (editing_user_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_companies_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_companies_on_account_id ON public.companies USING btree (account_id);


--
-- Name: index_companies_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_companies_on_discarded_at ON public.companies USING btree (discarded_at);


--
-- Name: index_companies_on_name_and_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_companies_on_name_and_account_id ON public.companies USING btree (name, account_id);


--
-- Name: index_companies_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_companies_on_slug ON public.companies USING btree (slug);


--
-- Name: index_company_article_templates_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_company_article_templates_on_account_id ON public.company_article_templates USING btree (account_id);


--
-- Name: index_company_article_templates_on_article_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_company_article_templates_on_article_id ON public.company_article_templates USING btree (article_id);


--
-- Name: index_company_article_templates_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_company_article_templates_on_company_id ON public.company_article_templates USING btree (company_id);


--
-- Name: index_company_variables_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_company_variables_on_account_id ON public.company_variables USING btree (account_id);


--
-- Name: index_company_variables_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_company_variables_on_company_id ON public.company_variables USING btree (company_id);


--
-- Name: index_configuration_types_on_integrator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_configuration_types_on_integrator_id ON public.configuration_types USING btree (integrator_id);


--
-- Name: index_custom_fast_facts_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_custom_fast_facts_on_company_id ON public.custom_fast_facts USING btree (company_id);


--
-- Name: index_dns_details_on_website_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_dns_details_on_website_id ON public.dns_details USING btree (website_id);


--
-- Name: index_domain_histories_on_domain_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_domain_histories_on_domain_id ON public.domain_histories USING btree (domain_id);


--
-- Name: index_domains_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_domains_on_account_id ON public.domains USING btree (account_id);


--
-- Name: index_domains_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_domains_on_company_id ON public.domains USING btree (company_id);


--
-- Name: index_domains_on_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_domains_on_name ON public.domains USING btree (name);


--
-- Name: index_dynamic_jobs_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_dynamic_jobs_on_account_id ON public.dynamic_jobs USING btree (account_id);


--
-- Name: index_dynamic_jobs_on_next_run_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_dynamic_jobs_on_next_run_at ON public.dynamic_jobs USING btree (next_run_at);


--
-- Name: index_expirations_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_expirations_on_account_id ON public.expirations USING btree (account_id);


--
-- Name: index_expirations_on_asset_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_expirations_on_asset_field_id ON public.expirations USING btree (asset_field_id);


--
-- Name: index_expirations_on_asset_layout_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_expirations_on_asset_layout_field_id ON public.expirations USING btree (asset_layout_field_id);


--
-- Name: index_expirations_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_expirations_on_company_id ON public.expirations USING btree (company_id);


--
-- Name: index_expirations_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_expirations_on_discarded_at ON public.expirations USING btree (discarded_at);


--
-- Name: index_expirations_on_expirationable_type_and_expirationable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_expirations_on_expirationable_type_and_expirationable_id ON public.expirations USING btree (expirationable_type, expirationable_id);


--
-- Name: index_export_items_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_export_items_on_account_id ON public.export_items USING btree (account_id);


--
-- Name: index_export_items_on_export_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_export_items_on_export_id ON public.export_items USING btree (export_id);


--
-- Name: index_exports_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_exports_on_account_id ON public.exports USING btree (account_id);


--
-- Name: index_flag_types_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_flag_types_on_account_id ON public.flag_types USING btree (account_id);


--
-- Name: index_flag_types_on_name_and_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_flag_types_on_name_and_account_id ON public.flag_types USING btree (name, account_id);


--
-- Name: index_flag_types_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_flag_types_on_slug ON public.flag_types USING btree (slug);


--
-- Name: index_flags_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_flags_on_account_id ON public.flags USING btree (account_id);


--
-- Name: index_flags_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_flags_on_company_id ON public.flags USING btree (company_id);


--
-- Name: index_flags_on_flag_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_flags_on_flag_type_id ON public.flags USING btree (flag_type_id);


--
-- Name: index_flags_on_flagable_type_and_flagable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_flags_on_flagable_type_and_flagable_id ON public.flags USING btree (flagable_type, flagable_id);


--
-- Name: index_flags_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_flags_on_user_id ON public.flags USING btree (user_id);


--
-- Name: index_folders_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_folders_on_account_id ON public.folders USING btree (account_id);


--
-- Name: index_folders_on_ancestry; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_folders_on_ancestry ON public.folders USING btree (ancestry);


--
-- Name: index_folders_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_folders_on_company_id ON public.folders USING btree (company_id);


--
-- Name: index_gold_standards_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_gold_standards_on_account_id ON public.gold_standards USING btree (account_id);


--
-- Name: index_gold_standards_on_asset_layout_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_gold_standards_on_asset_layout_id ON public.gold_standards USING btree (asset_layout_id);


--
-- Name: index_gold_standards_on_standardable_type_and_standardable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_gold_standards_on_standardable_type_and_standardable_id ON public.gold_standards USING btree (standardable_type, standardable_id);


--
-- Name: index_groups_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_groups_on_account_id ON public.groups USING btree (account_id);


--
-- Name: index_groups_on_name_and_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_groups_on_name_and_account_id ON public.groups USING btree (name, account_id);


--
-- Name: index_groups_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_groups_on_slug ON public.groups USING btree (slug);


--
-- Name: index_hits_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hits_on_account_id ON public.hits USING btree (account_id);


--
-- Name: index_hits_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hits_on_company_id ON public.hits USING btree (company_id);


--
-- Name: index_hits_on_hitable_type_and_hitable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hits_on_hitable_type_and_hitable_id ON public.hits USING btree (hitable_type, hitable_id);


--
-- Name: index_hits_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hits_on_user_id ON public.hits USING btree (user_id);


--
-- Name: index_imported_records_on_import_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_imported_records_on_import_id ON public.imported_records USING btree (import_id);


--
-- Name: index_imported_records_on_imported_recordable; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_imported_records_on_imported_recordable ON public.imported_records USING btree (imported_recordable_type, imported_recordable_id);


--
-- Name: index_imports_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_imports_on_account_id ON public.imports USING btree (account_id);


--
-- Name: index_imports_on_asset_layout_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_imports_on_asset_layout_id ON public.imports USING btree (asset_layout_id);


--
-- Name: index_integrator_cards_on_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_integrator_cards_on_asset_id ON public.integrator_cards USING btree (asset_id);


--
-- Name: index_integrator_cards_on_integrator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_integrator_cards_on_integrator_id ON public.integrator_cards USING btree (integrator_id);


--
-- Name: index_integrators_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_integrators_on_account_id ON public.integrators USING btree (account_id);


--
-- Name: index_integrators_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_integrators_on_company_id ON public.integrators USING btree (company_id);


--
-- Name: index_invitations_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_invitations_on_user_id ON public.invitations USING btree (user_id);


--
-- Name: index_logs_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_logs_on_account_id ON public.logs USING btree (account_id);


--
-- Name: index_logs_on_logable_type_and_logable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_logs_on_logable_type_and_logable_id ON public.logs USING btree (logable_type, logable_id);


--
-- Name: index_logs_on_record_type_and_record_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_logs_on_record_type_and_record_id ON public.logs USING btree (record_type, record_id);


--
-- Name: index_matchers_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_matchers_on_account_id ON public.matchers USING btree (account_id);


--
-- Name: index_matchers_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_matchers_on_company_id ON public.matchers USING btree (company_id);


--
-- Name: index_matchers_on_integrator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_matchers_on_integrator_id ON public.matchers USING btree (integrator_id);


--
-- Name: index_password_folders_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_password_folders_on_company_id ON public.password_folders USING btree (company_id);


--
-- Name: index_password_folders_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_password_folders_on_slug ON public.password_folders USING btree (slug);


--
-- Name: index_password_requests_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_password_requests_on_discarded_at ON public.password_requests USING btree (discarded_at);


--
-- Name: index_password_requests_on_portal_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_password_requests_on_portal_id ON public.password_requests USING btree (portal_id);


--
-- Name: index_password_requests_on_requestable_type_and_requestable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_password_requests_on_requestable_type_and_requestable_id ON public.password_requests USING btree (requestable_type, requestable_id);


--
-- Name: index_password_requests_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_password_requests_on_user_id ON public.password_requests USING btree (user_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_photos_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_photos_on_account_id ON public.photos USING btree (account_id);


--
-- Name: index_photos_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_photos_on_discarded_at ON public.photos USING btree (discarded_at);


--
-- Name: index_photos_on_photoable_type_and_photoable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_photos_on_photoable_type_and_photoable_id ON public.photos USING btree (photoable_type, photoable_id);


--
-- Name: index_pins_on_pinable_type_and_pinable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_pins_on_pinable_type_and_pinable_id ON public.pins USING btree (pinable_type, pinable_id);


--
-- Name: index_pins_on_user_id_and_pinable_type_and_pinable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_pins_on_user_id_and_pinable_type_and_pinable_id ON public.pins USING btree (user_id, pinable_type, pinable_id);


--
-- Name: index_portal_items_on_asset_layout_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_portal_items_on_asset_layout_id ON public.portal_items USING btree (asset_layout_id);


--
-- Name: index_portal_items_on_portal_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_portal_items_on_portal_id ON public.portal_items USING btree (portal_id);


--
-- Name: index_portal_items_on_portalable_type_and_portalable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_portal_items_on_portalable_type_and_portalable_id ON public.portal_items USING btree (portalable_type, portalable_id);


--
-- Name: index_portal_links_on_portal_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_portal_links_on_portal_id ON public.portal_links USING btree (portal_id);


--
-- Name: index_portals_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_portals_on_company_id ON public.portals USING btree (company_id);


--
-- Name: index_procedure_tasks_on_procedure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_procedure_tasks_on_procedure_id ON public.procedure_tasks USING btree (procedure_id);


--
-- Name: index_procedure_tasks_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_procedure_tasks_on_user_id ON public.procedure_tasks USING btree (user_id);


--
-- Name: index_procedures_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_procedures_on_account_id ON public.procedures USING btree (account_id);


--
-- Name: index_procedures_on_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_procedures_on_asset_id ON public.procedures USING btree (asset_id);


--
-- Name: index_procedures_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_procedures_on_company_id ON public.procedures USING btree (company_id);


--
-- Name: index_procedures_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_procedures_on_discarded_at ON public.procedures USING btree (discarded_at);


--
-- Name: index_procedures_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_procedures_on_slug ON public.procedures USING btree (slug);


--
-- Name: index_public_photos_on_record_type_and_record_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_public_photos_on_record_type_and_record_id ON public.public_photos USING btree (record_type, record_id);


--
-- Name: index_pwned_passwords_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_pwned_passwords_on_account_id ON public.pwned_passwords USING btree (account_id);


--
-- Name: index_pwned_passwords_on_asset_password_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_pwned_passwords_on_asset_password_id ON public.pwned_passwords USING btree (asset_password_id);


--
-- Name: index_pwned_passwords_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_pwned_passwords_on_company_id ON public.pwned_passwords USING btree (company_id);


--
-- Name: index_recordings_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_recordings_on_account_id ON public.recordings USING btree (account_id);


--
-- Name: index_recordings_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_recordings_on_company_id ON public.recordings USING btree (company_id);


--
-- Name: index_recordings_on_recordingable_type_and_recordingable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_recordings_on_recordingable_type_and_recordingable_id ON public.recordings USING btree (recordingable_type, recordingable_id);


--
-- Name: index_recordings_on_user_id_and_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_recordings_on_user_id_and_action ON public.recordings USING btree (user_id, action);


--
-- Name: index_relations_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relations_on_account_id ON public.relations USING btree (account_id);


--
-- Name: index_relations_on_fromable_type_and_fromable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relations_on_fromable_type_and_fromable_id ON public.relations USING btree (fromable_type, fromable_id);


--
-- Name: index_relations_on_toable_type_and_toable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relations_on_toable_type_and_toable_id ON public.relations USING btree (toable_type, toable_id);


--
-- Name: index_restrictions_on_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_restrictions_on_group_id ON public.restrictions USING btree (group_id);


--
-- Name: index_restrictions_on_restrictable_type_and_restrictable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_restrictions_on_restrictable_type_and_restrictable_id ON public.restrictions USING btree (restrictable_type, restrictable_id);


--
-- Name: index_rules_on_asset_layout_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_rules_on_asset_layout_id ON public.rules USING btree (asset_layout_id);


--
-- Name: index_rules_on_configuration_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_rules_on_configuration_type_id ON public.rules USING btree (configuration_type_id);


--
-- Name: index_rules_on_integrator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_rules_on_integrator_id ON public.rules USING btree (integrator_id);


--
-- Name: index_secure_notes_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_secure_notes_on_company_id ON public.secure_notes USING btree (company_id);


--
-- Name: index_shares_on_shareable_type_and_shareable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_shares_on_shareable_type_and_shareable_id ON public.shares USING btree (shareable_type, shareable_id);


--
-- Name: index_shares_on_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_shares_on_token ON public.shares USING btree (token);


--
-- Name: index_ssl_details_on_website_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ssl_details_on_website_id ON public.ssl_details USING btree (website_id);


--
-- Name: index_tags_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_tags_on_company_id ON public.tags USING btree (company_id);


--
-- Name: index_tags_on_tagable_type_and_tagable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_tags_on_tagable_type_and_tagable_id ON public.tags USING btree (tagable_type, tagable_id);


--
-- Name: index_uploads_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_uploads_on_account_id ON public.uploads USING btree (account_id);


--
-- Name: index_uploads_on_discarded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_uploads_on_discarded_at ON public.uploads USING btree (discarded_at);


--
-- Name: index_uploads_on_uploadable_type_and_uploadable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_uploads_on_uploadable_type_and_uploadable_id ON public.uploads USING btree (uploadable_type, uploadable_id);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_users_on_account_id ON public.users USING btree (account_id);


--
-- Name: index_users_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_users_on_company_id ON public.users USING btree (company_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_users_on_group_id ON public.users USING btree (group_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_settings; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_users_on_settings ON public.users USING gin (settings);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_slug ON public.users USING btree (slug);


--
-- Name: index_vault_passwords_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_vault_passwords_on_account_id ON public.vault_passwords USING btree (account_id);


--
-- Name: index_vault_passwords_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_vault_passwords_on_user_id ON public.vault_passwords USING btree (user_id);


--
-- Name: index_website_histories_on_website_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_website_histories_on_website_id ON public.website_histories USING btree (website_id);


--
-- Name: index_websites_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_websites_on_account_id ON public.websites USING btree (account_id);


--
-- Name: index_websites_on_asset_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_websites_on_asset_field_id ON public.websites USING btree (asset_field_id);


--
-- Name: index_websites_on_company_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_websites_on_company_id ON public.websites USING btree (company_id);


--
-- Name: index_whois_details_on_website_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_whois_details_on_website_id ON public.whois_details USING btree (website_id);


--
-- Name: matchers fk_rails_018e153f17; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchers
    ADD CONSTRAINT fk_rails_018e153f17 FOREIGN KEY (integrator_id) REFERENCES public.integrators(id) ON DELETE CASCADE;


--
-- Name: integrator_cards fk_rails_02f689adf1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrator_cards
    ADD CONSTRAINT fk_rails_02f689adf1 FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: asset_fields fk_rails_04e8977747; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_fields
    ADD CONSTRAINT fk_rails_04e8977747 FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: procedures fk_rails_07ba489467; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT fk_rails_07ba489467 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: agreements fk_rails_0b92144358; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT fk_rails_0b92144358 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: company_variables fk_rails_103f94f27f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_variables
    ADD CONSTRAINT fk_rails_103f94f27f FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: recordings fk_rails_13137dd26a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT fk_rails_13137dd26a FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: imports fk_rails_138d41de18; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imports
    ADD CONSTRAINT fk_rails_138d41de18 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: portal_links fk_rails_142a100e88; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portal_links
    ADD CONSTRAINT fk_rails_142a100e88 FOREIGN KEY (portal_id) REFERENCES public.portals(id);


--
-- Name: portal_items fk_rails_148dd886fb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portal_items
    ADD CONSTRAINT fk_rails_148dd886fb FOREIGN KEY (portal_id) REFERENCES public.portals(id);


--
-- Name: websites fk_rails_15577eb418; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.websites
    ADD CONSTRAINT fk_rails_15577eb418 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: matchers fk_rails_1e102116ec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchers
    ADD CONSTRAINT fk_rails_1e102116ec FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: flags fk_rails_20f9b20913; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT fk_rails_20f9b20913 FOREIGN KEY (flag_type_id) REFERENCES public.flag_types(id) ON DELETE CASCADE;


--
-- Name: flags fk_rails_21fdda9023; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT fk_rails_21fdda9023 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: asset_fields fk_rails_22300bb00f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_fields
    ADD CONSTRAINT fk_rails_22300bb00f FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- Name: company_article_templates fk_rails_22741d11ae; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_article_templates
    ADD CONSTRAINT fk_rails_22741d11ae FOREIGN KEY (article_id) REFERENCES public.articles(id) ON DELETE CASCADE;


--
-- Name: asset_layout_fields fk_rails_2bd74cc94b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layout_fields
    ADD CONSTRAINT fk_rails_2bd74cc94b FOREIGN KEY (asset_layout_id) REFERENCES public.asset_layouts(id) ON DELETE CASCADE;


--
-- Name: asset_layouts fk_rails_30bf2bf677; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layouts
    ADD CONSTRAINT fk_rails_30bf2bf677 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: password_requests fk_rails_30d4e9f191; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_requests
    ADD CONSTRAINT fk_rails_30d4e9f191 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: restrictions fk_rails_31f2d24054; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restrictions
    ADD CONSTRAINT fk_rails_31f2d24054 FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: export_items fk_rails_3523ea6f2b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.export_items
    ADD CONSTRAINT fk_rails_3523ea6f2b FOREIGN KEY (export_id) REFERENCES public.exports(id);


--
-- Name: folders fk_rails_3623ff8b80; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT fk_rails_3623ff8b80 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: configuration_types fk_rails_38f326864e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration_types
    ADD CONSTRAINT fk_rails_38f326864e FOREIGN KEY (integrator_id) REFERENCES public.integrators(id);


--
-- Name: relations fk_rails_3f48fd1493; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_rails_3f48fd1493 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: rules fk_rails_418b9efb2a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules
    ADD CONSTRAINT fk_rails_418b9efb2a FOREIGN KEY (integrator_id) REFERENCES public.integrators(id);


--
-- Name: rules fk_rails_4519989480; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules
    ADD CONSTRAINT fk_rails_4519989480 FOREIGN KEY (asset_layout_id) REFERENCES public.asset_layouts(id);


--
-- Name: portals fk_rails_46018872cc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portals
    ADD CONSTRAINT fk_rails_46018872cc FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: vault_passwords fk_rails_4a5677949f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vault_passwords
    ADD CONSTRAINT fk_rails_4a5677949f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: website_histories fk_rails_4b419908aa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.website_histories
    ADD CONSTRAINT fk_rails_4b419908aa FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE;


--
-- Name: autotask_products fk_rails_4bf0471da4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autotask_products
    ADD CONSTRAINT fk_rails_4bf0471da4 FOREIGN KEY (integrator_id) REFERENCES public.integrators(id);


--
-- Name: pins fk_rails_51b0c024f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pins
    ADD CONSTRAINT fk_rails_51b0c024f1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: expirations fk_rails_51bde13f57; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expirations
    ADD CONSTRAINT fk_rails_51bde13f57 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: imported_records fk_rails_539ed7a071; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imported_records
    ADD CONSTRAINT fk_rails_539ed7a071 FOREIGN KEY (import_id) REFERENCES public.imports(id) ON DELETE CASCADE;


--
-- Name: asset_passwords fk_rails_5a29361e6f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_passwords
    ADD CONSTRAINT fk_rails_5a29361e6f FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: imports fk_rails_5aeb8e3f70; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imports
    ADD CONSTRAINT fk_rails_5aeb8e3f70 FOREIGN KEY (asset_layout_id) REFERENCES public.asset_layouts(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_61ac11da2b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_61ac11da2b FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: exports fk_rails_65c6ec4a5e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exports
    ADD CONSTRAINT fk_rails_65c6ec4a5e FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: procedure_tasks fk_rails_673f74c9b4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_tasks
    ADD CONSTRAINT fk_rails_673f74c9b4 FOREIGN KEY (procedure_id) REFERENCES public.procedures(id) ON DELETE CASCADE;


--
-- Name: pwned_passwords fk_rails_6a3b3c2709; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pwned_passwords
    ADD CONSTRAINT fk_rails_6a3b3c2709 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: company_article_templates fk_rails_6b423949f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_article_templates
    ADD CONSTRAINT fk_rails_6b423949f1 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: companies fk_rails_6c47690f56; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_6c47690f56 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: dns_details fk_rails_6f2b62f4e7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dns_details
    ADD CONSTRAINT fk_rails_6f2b62f4e7 FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE;


--
-- Name: domains fk_rails_6f6670cc65; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT fk_rails_6f6670cc65 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: expirations fk_rails_71ffbf073e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expirations
    ADD CONSTRAINT fk_rails_71ffbf073e FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_7682a3bdfe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_7682a3bdfe FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: domains fk_rails_76d46ed28d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT fk_rails_76d46ed28d FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: procedure_tasks fk_rails_770cf64377; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_tasks
    ADD CONSTRAINT fk_rails_770cf64377 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: hits fk_rails_78b5985ce6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hits
    ADD CONSTRAINT fk_rails_78b5985ce6 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: dynamic_jobs fk_rails_7b74485607; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dynamic_jobs
    ADD CONSTRAINT fk_rails_7b74485607 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: company_variables fk_rails_7bd689950e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_variables
    ADD CONSTRAINT fk_rails_7bd689950e FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: hits fk_rails_7e18b3af70; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hits
    ADD CONSTRAINT fk_rails_7e18b3af70 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: matchers fk_rails_7e40b17a9a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchers
    ADD CONSTRAINT fk_rails_7e40b17a9a FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: invitations fk_rails_7eae413fe6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_7eae413fe6 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: portal_items fk_rails_7fa0bc1d9d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portal_items
    ADD CONSTRAINT fk_rails_7fa0bc1d9d FOREIGN KEY (asset_layout_id) REFERENCES public.asset_layouts(id);


--
-- Name: assets fk_rails_8867787cbc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_rails_8867787cbc FOREIGN KEY (asset_layout_id) REFERENCES public.asset_layouts(id) ON DELETE CASCADE;


--
-- Name: password_requests fk_rails_89cd191363; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_requests
    ADD CONSTRAINT fk_rails_89cd191363 FOREIGN KEY (portal_id) REFERENCES public.portals(id);


--
-- Name: pwned_passwords fk_rails_8e81d4d883; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pwned_passwords
    ADD CONSTRAINT fk_rails_8e81d4d883 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: articles fk_rails_9033ab037f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_9033ab037f FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: rules fk_rails_91314e5391; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules
    ADD CONSTRAINT fk_rails_91314e5391 FOREIGN KEY (configuration_type_id) REFERENCES public.configuration_types(id);


--
-- Name: logs fk_rails_92170bd48f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT fk_rails_92170bd48f FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: assets fk_rails_930cea5f95; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_rails_930cea5f95 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: hits fk_rails_932d6a3eb8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hits
    ADD CONSTRAINT fk_rails_932d6a3eb8 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: websites fk_rails_94c1021584; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.websites
    ADD CONSTRAINT fk_rails_94c1021584 FOREIGN KEY (asset_field_id) REFERENCES public.asset_fields(id);


--
-- Name: asset_layouts fk_rails_963b699ea6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layouts
    ADD CONSTRAINT fk_rails_963b699ea6 FOREIGN KEY (sidebar_folder_id) REFERENCES public.sidebar_folders(id);


--
-- Name: articles fk_rails_9ae110b456; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_9ae110b456 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: procedures fk_rails_9b29307d44; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT fk_rails_9b29307d44 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: integrators fk_rails_a5c425f89f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrators
    ADD CONSTRAINT fk_rails_a5c425f89f FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: alerts fk_rails_a6a9ff5e33; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_rails_a6a9ff5e33 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: ssl_details fk_rails_aa8e70a7c1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssl_details
    ADD CONSTRAINT fk_rails_aa8e70a7c1 FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE;


--
-- Name: integrator_cards fk_rails_aada1fb1a6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrator_cards
    ADD CONSTRAINT fk_rails_aada1fb1a6 FOREIGN KEY (integrator_id) REFERENCES public.integrators(id) ON DELETE CASCADE;


--
-- Name: export_items fk_rails_b488fe9838; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.export_items
    ADD CONSTRAINT fk_rails_b488fe9838 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: vault_passwords fk_rails_b693026042; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vault_passwords
    ADD CONSTRAINT fk_rails_b693026042 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: secure_notes fk_rails_bbcd0cf625; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secure_notes
    ADD CONSTRAINT fk_rails_bbcd0cf625 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: recordings fk_rails_be0ed499f4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT fk_rails_be0ed499f4 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: pwned_passwords fk_rails_bebf098056; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pwned_passwords
    ADD CONSTRAINT fk_rails_bebf098056 FOREIGN KEY (asset_password_id) REFERENCES public.asset_passwords(id) ON DELETE CASCADE;


--
-- Name: uploads fk_rails_c08d6b58ab; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT fk_rails_c08d6b58ab FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: company_article_templates fk_rails_c0ed43b30f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_article_templates
    ADD CONSTRAINT fk_rails_c0ed43b30f FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: recordings fk_rails_c224d82773; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT fk_rails_c224d82773 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: asset_layouts fk_rails_cbbe295b5b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_layouts
    ADD CONSTRAINT fk_rails_cbbe295b5b FOREIGN KEY (integrator_id) REFERENCES public.integrators(id);


--
-- Name: tags fk_rails_cd310945e7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_rails_cd310945e7 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: folders fk_rails_d2aa0af69f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT fk_rails_d2aa0af69f FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: expirations fk_rails_d2da59e348; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expirations
    ADD CONSTRAINT fk_rails_d2da59e348 FOREIGN KEY (asset_layout_field_id) REFERENCES public.asset_layout_fields(id) ON DELETE CASCADE;


--
-- Name: custom_fast_facts fk_rails_d4de7b7fdb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_fast_facts
    ADD CONSTRAINT fk_rails_d4de7b7fdb FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: articles fk_rails_d5a88a358e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_d5a88a358e FOREIGN KEY (folder_id) REFERENCES public.folders(id);


--
-- Name: flags fk_rails_d7842de637; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT fk_rails_d7842de637 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: asset_passwords fk_rails_d8318e6d5f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_passwords
    ADD CONSTRAINT fk_rails_d8318e6d5f FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: asset_passwords fk_rails_da274579f7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_passwords
    ADD CONSTRAINT fk_rails_da274579f7 FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- Name: flags fk_rails_df1598df72; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT fk_rails_df1598df72 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: whois_details fk_rails_e1198128d1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whois_details
    ADD CONSTRAINT fk_rails_e1198128d1 FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE;


--
-- Name: websites fk_rails_e171dc7069; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.websites
    ADD CONSTRAINT fk_rails_e171dc7069 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: expirations fk_rails_e2c8b1d2a5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expirations
    ADD CONSTRAINT fk_rails_e2c8b1d2a5 FOREIGN KEY (asset_field_id) REFERENCES public.asset_fields(id) ON DELETE CASCADE;


--
-- Name: domain_histories fk_rails_ebb501c792; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domain_histories
    ADD CONSTRAINT fk_rails_ebb501c792 FOREIGN KEY (domain_id) REFERENCES public.domains(id) ON DELETE CASCADE;


--
-- Name: groups fk_rails_ed4ff9a299; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT fk_rails_ed4ff9a299 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: procedures fk_rails_f2f3b08a92; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT fk_rails_f2f3b08a92 FOREIGN KEY (asset_id) REFERENCES public.assets(id);


--
-- Name: integrators fk_rails_f3c73cf751; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integrators
    ADD CONSTRAINT fk_rails_f3c73cf751 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: users fk_rails_f40b3f4da6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_f40b3f4da6 FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: api_keys fk_rails_f4470e16d5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT fk_rails_f4470e16d5 FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: asset_fields fk_rails_fff598ab66; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_fields
    ADD CONSTRAINT fk_rails_fff598ab66 FOREIGN KEY (asset_layout_field_id) REFERENCES public.asset_layout_fields(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

