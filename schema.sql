--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authz_approvals; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE authz_approvals (
    user_id character varying(36) NOT NULL,
    client_id character varying(36) NOT NULL,
    scope character varying(255) NOT NULL,
    expiresat timestamp without time zone DEFAULT now() NOT NULL,
    status character varying(50) DEFAULT 'APPROVED'::character varying NOT NULL,
    lastmodifiedat timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE authz_approvals OWNER TO postgres;

--
-- Name: authz_approvals_old; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE authz_approvals_old (
    username character varying(255) NOT NULL,
    clientid character varying(36) NOT NULL,
    scope character varying(255) NOT NULL,
    expiresat timestamp without time zone DEFAULT now() NOT NULL,
    status character varying(50) DEFAULT 'APPROVED'::character varying NOT NULL,
    lastmodifiedat timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE authz_approvals_old OWNER TO postgres;

--
-- Name: expiring_code_store; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE expiring_code_store (
    code character varying(255) NOT NULL,
    expiresat bigint NOT NULL,
    data text NOT NULL
);


ALTER TABLE expiring_code_store OWNER TO postgres;

--
-- Name: external_group_mapping; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE external_group_mapping (
    group_id character varying(36) NOT NULL,
    external_group character varying(255) NOT NULL,
    added timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE external_group_mapping OWNER TO postgres;

--
-- Name: group_membership; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_membership (
    group_id character varying(36) NOT NULL,
    member_id character varying(36) NOT NULL,
    member_type character varying(8) DEFAULT 'USER'::character varying NOT NULL,
    authorities character varying(255) DEFAULT 'READ'::character varying NOT NULL,
    added timestamp without time zone DEFAULT now() NOT NULL,
    origin character varying(36) DEFAULT 'uaa'::character varying NOT NULL
);


ALTER TABLE group_membership OWNER TO postgres;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE groups (
    id character varying(36) NOT NULL,
    displayname character varying(255) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    lastmodified timestamp without time zone DEFAULT now() NOT NULL,
    version bigint DEFAULT 0 NOT NULL
);


ALTER TABLE groups OWNER TO postgres;

--
-- Name: oauth_client_details; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_client_details (
    client_id character varying(256) NOT NULL,
    resource_ids character varying(1024),
    client_secret character varying(256),
    scope character varying(1024),
    authorized_grant_types character varying(256),
    web_server_redirect_uri character varying(1024),
    authorities character varying(1024),
    access_token_validity integer,
    refresh_token_validity integer DEFAULT 0,
    additional_information character varying(4096)
);


ALTER TABLE oauth_client_details OWNER TO postgres;

--
-- Name: oauth_code; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_code (
    code character varying(256),
    authentication bytea
);


ALTER TABLE oauth_code OWNER TO postgres;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE schema_version (
    version_rank integer NOT NULL,
    installed_rank integer NOT NULL,
    version character varying(50) NOT NULL,
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE schema_version OWNER TO postgres;

--
-- Name: sec_audit; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sec_audit (
    principal_id character(36) NOT NULL,
    event_type integer NOT NULL,
    origin character varying(255) NOT NULL,
    event_data character varying(255),
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE sec_audit OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id character(36) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    lastmodified timestamp without time zone DEFAULT now() NOT NULL,
    version bigint DEFAULT 0 NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    authority bigint DEFAULT 0 NOT NULL,
    givenname character varying(255),
    familyname character varying(255),
    active boolean DEFAULT true,
    phonenumber character varying(255),
    authorities character varying(1024) DEFAULT 'uaa.user'::character varying,
    verified boolean DEFAULT false NOT NULL,
    origin character varying(36) DEFAULT 'uaa'::character varying NOT NULL,
    external_id character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: authz_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authz_approvals_old
    ADD CONSTRAINT authz_approvals_pkey PRIMARY KEY (username, clientid, scope);


--
-- Name: expiring_code_store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expiring_code_store
    ADD CONSTRAINT expiring_code_store_pkey PRIMARY KEY (code);


--
-- Name: external_group_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY external_group_mapping
    ADD CONSTRAINT external_group_mapping_pkey PRIMARY KEY (group_id, external_group);


--
-- Name: group_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_membership
    ADD CONSTRAINT group_membership_pkey PRIMARY KEY (group_id, member_id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: new_authz_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authz_approvals
    ADD CONSTRAINT new_authz_approvals_pkey PRIMARY KEY (user_id, client_id, scope);


--
-- Name: oauth_client_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY oauth_client_details
    ADD CONSTRAINT oauth_client_details_pkey PRIMARY KEY (client_id);


--
-- Name: schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (version);


--
-- Name: unique_uk_2; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT unique_uk_2 UNIQUE (displayname);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: audit_created; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX audit_created ON sec_audit USING btree (created);


--
-- Name: audit_principal; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX audit_principal ON sec_audit USING btree (principal_id);


--
-- Name: schema_version_ir_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX schema_version_ir_idx ON schema_version USING btree (installed_rank);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX schema_version_s_idx ON schema_version USING btree (success);


--
-- Name: schema_version_vr_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX schema_version_vr_idx ON schema_version USING btree (version_rank);


--
-- Name: unique_uk_1_1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (version_rank, installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	1.5.2	initial db	SQL	V1_5_2__initial_db.sql	-642457668	postgres	2015-09-30 13:08:31.325582	168	t
2	2	1.5.3	InitialDBScript	JDBC	org.cloudfoundry.identity.uaa.db.postgresql.V1_5_3__InitialDBScript	\N	postgres	2015-09-30 13:08:31.603508	32	t
3	3	1.5.4	NormalizeTableAndColumnNames	SPRING_JDBC	org.cloudfoundry.identity.uaa.db.postgresql.V1_5_4__NormalizeTableAndColumnNames	\N	postgres	2015-09-30 13:08:31.655631	37	t
4	4	1.5.5	CreateExpiringCodeStore	SQL	V1_5_5__CreateExpiringCodeStore.sql	284135900	postgres	2015-09-30 13:08:31.718391	8	t
5	5	1.6.0	ExtendAuthzApprovalUsername	SQL	V1_6_0__ExtendAuthzApprovalUsername.sql	-2020909403	postgres	2015-09-30 13:08:31.737077	12	t
6	6	1.7.0	OriginAndExternalIDColumns	SQL	V1_7_0__OriginAndExternalIDColumns.sql	201133337	postgres	2015-09-30 13:08:31.761077	25	t
7	7	1.7.1	OriginForGroupMembershipColumns	SQL	V1_7_1__OriginForGroupMembershipColumns.sql	-1044457386	postgres	2015-09-30 13:08:31.795655	6	t
8	8	1.7.3	ExtendClientAuthorities	SQL	V1_7_3__ExtendClientAuthorities.sql	-73833988	postgres	2015-09-30 13:08:31.812906	5	t
\.


CREATE UNIQUE INDEX unique_uk_1_1 ON users USING btree (lower((username)::text));


--
-- Name: users_unique_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX users_unique_key ON users USING btree (lower((username)::text), origin);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

