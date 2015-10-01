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
-- Data for Name: external_group_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY external_group_mapping (group_id, external_group, added) FROM stdin;
19153b7a-13a0-46bf-a77d-94d03c55f34e	cn=test_org,ou=people,o=springsource,o=org	2015-09-30 19:28:24.255
\.



--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY groups (id, displayname, created, lastmodified, version) FROM stdin;
c5feb1d4-334f-44f5-92ed-b39c914d869b	scim.userids	2015-09-30 19:28:22.13	2015-09-30 19:28:22.13	0
6be396f7-b12a-4c3b-86dc-58090a3bc425	cloud_controller_service_permissions.read	2015-09-30 19:28:22.134	2015-09-30 19:28:22.134	0
18b6b214-39ce-466f-b760-c7df418cb034	password.write	2015-09-30 19:28:22.138	2015-09-30 19:28:22.138	0
64403311-924e-4f51-9e78-bc519adf1aff	cloud_controller.write	2015-09-30 19:28:22.141	2015-09-30 19:28:22.141	0
3d15ae49-caa6-4318-b88b-8ac35cc5b252	scim.me	2015-09-30 19:28:22.146	2015-09-30 19:28:22.146	0
836ea31e-6d39-42f1-821e-bd2443d9fd5d	openid	2015-09-30 19:28:22.149	2015-09-30 19:28:22.15	0
979d2fb9-81a2-4acb-9fb9-820ed58ac2d0	oauth.approvals	2015-09-30 19:28:22.152	2015-09-30 19:28:22.152	0
bbb1c228-305f-486f-82ac-31faf40cc1df	cloud_controller.read	2015-09-30 19:28:22.156	2015-09-30 19:28:22.156	0
42e0bc07-678f-44b0-8c4d-00a0a6da766d	approvals.me	2015-09-30 19:28:22.159	2015-09-30 19:28:22.159	0
5816b070-4548-4ee4-92da-6c5291508f96	uaa.user	2015-09-30 19:28:22.162	2015-09-30 19:28:22.162	0
8630411a-1456-4fb9-9cf6-701661c86173	clients.admin	2015-09-30 19:28:24.197	2015-09-30 19:28:24.197	0
60bc612c-383d-41e0-8e04-60d545423443	clients.read	2015-09-30 19:28:24.199	2015-09-30 19:28:24.199	0
9f0d91f8-2760-45fc-8f94-543eeeaa31b7	clients.secret	2015-09-30 19:28:24.201	2015-09-30 19:28:24.201	0
d1728a85-f241-403f-b8ac-1fed9df402c4	clients.write	2015-09-30 19:28:24.203	2015-09-30 19:28:24.203	0
562223b6-56b8-4d4c-b299-dc2bb224c782	cloud_controller.admin	2015-09-30 19:28:24.205	2015-09-30 19:28:24.205	0
b9241dc5-e6bf-494c-af34-9b08d528deed	scim.read	2015-09-30 19:28:24.207	2015-09-30 19:28:24.207	0
44a87ed0-4bb0-442d-94e0-89baddd72536	scim.write	2015-09-30 19:28:24.21	2015-09-30 19:28:24.21	0
dab31fd2-ec7a-4c71-a372-dbc5e10e9a54	uaa.admin	2015-09-30 19:28:24.212	2015-09-30 19:28:24.212	0
b83d55e0-5fba-4821-bad7-b2172d099cc7	uaa.resource	2015-09-30 19:28:24.214	2015-09-30 19:28:24.214	0
19153b7a-13a0-46bf-a77d-94d03c55f34e	organizations.acme	2015-09-30 19:28:24.252	2015-09-30 19:28:24.252	0
\.


--
-- Data for Name: oauth_client_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oauth_client_details (client_id, resource_ids, client_secret, scope, authorized_grant_types, web_server_redirect_uri, authorities, access_token_validity, refresh_token_validity, additional_information) FROM stdin;
sultans	none	$2a$10$DV1g.P/DDlAJlRSXNOwf7OmPTv0IGduz3a6F0o2GdebNfPw39JGj.	password.write,scim.read,scim.write	client_credentials	\N	uaa.resource,scim.read,scim.write,password.write	\N	\N	{}
uluwatu	none	$2a$10$8Zdi3u/0vtusnkwQumzH6OnePl2mObmjKBWs2GqUS04QHWMTZWTRi	cloudbreak.blueprints,cloudbreak.blueprints.read,cloudbreak.credentials,cloudbreak.credentials.read,cloudbreak.events,cloudbreak.networks.read,cloudbreak.recipes,cloudbreak.recipes.read,cloudbreak.securitygroups.read,cloudbreak.stacks,cloudbreak.stacks.read,cloudbreak.templates,cloudbreak.templates.read,cloudbreak.usages.account,cloudbreak.usages.global,cloudbreak.usages.user,openid,password.write,periscope.cluster	authorization_code,client_credentials,refresh_token	http://192.168.59.103:3000/authorize	cloudbreak.subscribe	\N	\N	{}
periscope	none	$2a$10$qSWroOzNSRhD2GRvY6eIjuOyHDcGeNzihApfJOuUgNu9jDSPrkq3y	none	client_credentials	\N	cloudbreak.autoscale,uaa.resource,scim.read	\N	\N	{}
cloudbreak	none	$2a$10$Hv8593iJ6i6UeovW0xTfx.r3Na2Vr7XmgtLiMUVg9A3yGBBYarWNC	password.write,scim.read,scim.write	client_credentials	\N	uaa.resource,scim.read,scim.write,password.write	\N	\N	{}
cloudbreak_shell	none	\N	cloudbreak.blueprints,cloudbreak.blueprints.read,cloudbreak.credentials,cloudbreak.credentials.read,cloudbreak.events,cloudbreak.networks.read,cloudbreak.recipes,cloudbreak.recipes.read,cloudbreak.securitygroups.read,cloudbreak.stacks,cloudbreak.stacks.read,cloudbreak.templates,cloudbreak.templates.read,cloudbreak.usages.account,cloudbreak.usages.global,cloudbreak.usages.user,openid,password.write	implicit	http://cloudbreak.shell	uaa.none	\N	\N	{"autoapprove":true}
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (version_rank, installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	1.5.2	initial db	SQL	V1_5_2__initial_db.sql	-642457668	postgres	2015-09-30 19:28:21.251781	74	t
2	2	1.5.3	InitialDBScript	JDBC	org.cloudfoundry.identity.uaa.db.postgresql.V1_5_3__InitialDBScript	\N	postgres	2015-09-30 19:28:21.39543	22	t
3	3	1.5.4	NormalizeTableAndColumnNames	SPRING_JDBC	org.cloudfoundry.identity.uaa.db.postgresql.V1_5_4__NormalizeTableAndColumnNames	\N	postgres	2015-09-30 19:28:21.429158	24	t
4	4	1.5.5	CreateExpiringCodeStore	SQL	V1_5_5__CreateExpiringCodeStore.sql	284135900	postgres	2015-09-30 19:28:21.463124	5	t
5	5	1.6.0	ExtendAuthzApprovalUsername	SQL	V1_6_0__ExtendAuthzApprovalUsername.sql	-2020909403	postgres	2015-09-30 19:28:21.477188	3	t
6	6	1.7.0	OriginAndExternalIDColumns	SQL	V1_7_0__OriginAndExternalIDColumns.sql	201133337	postgres	2015-09-30 19:28:21.490127	21	t
7	7	1.7.1	OriginForGroupMembershipColumns	SQL	V1_7_1__OriginForGroupMembershipColumns.sql	-1044457386	postgres	2015-09-30 19:28:21.523685	4	t
8	8	1.7.3	ExtendClientAuthorities	SQL	V1_7_3__ExtendClientAuthorities.sql	-73833988	postgres	2015-09-30 19:28:21.538835	3	t
\.


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

