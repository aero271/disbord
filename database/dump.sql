--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 (Debian 15.10-0+deb12u1)
-- Dumped by pg_dump version 15.10 (Debian 15.10-0+deb12u1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chats; Type: TABLE; Schema: public; Owner: dbuser
--

CREATE TABLE public.chats (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.chats OWNER TO dbuser;

--
-- Name: chats_id_seq; Type: SEQUENCE; Schema: public; Owner: dbuser
--

CREATE SEQUENCE public.chats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chats_id_seq OWNER TO dbuser;

--
-- Name: chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbuser
--

ALTER SEQUENCE public.chats_id_seq OWNED BY public.chats.id;


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: dbuser
--

CREATE TABLE public.friendships (
    id integer NOT NULL,
    time_added timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_1 integer,
    user_2 integer
);


ALTER TABLE public.friendships OWNER TO dbuser;

--
-- Name: friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: dbuser
--

CREATE SEQUENCE public.friendships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friendships_id_seq OWNER TO dbuser;

--
-- Name: friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbuser
--

ALTER SEQUENCE public.friendships_id_seq OWNED BY public.friendships.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: dbuser
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    content text,
    user_id integer,
    chat_id integer,
    time_sent timestamp without time zone DEFAULT now()
);


ALTER TABLE public.messages OWNER TO dbuser;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: dbuser
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO dbuser;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbuser
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: dbuser
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100)
);


ALTER TABLE public.users OWNER TO dbuser;

--
-- Name: users_chats; Type: TABLE; Schema: public; Owner: dbuser
--

CREATE TABLE public.users_chats (
    user_id integer NOT NULL,
    chat_id integer NOT NULL,
    date_joined date DEFAULT CURRENT_DATE
);


ALTER TABLE public.users_chats OWNER TO dbuser;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: dbuser
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO dbuser;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbuser
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: chats id; Type: DEFAULT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.chats ALTER COLUMN id SET DEFAULT nextval('public.chats_id_seq'::regclass);


--
-- Name: friendships id; Type: DEFAULT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.friendships ALTER COLUMN id SET DEFAULT nextval('public.friendships_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: dbuser
--

COPY public.chats (id, name) FROM stdin;
1	test
2	test2
3	test4
4	johnsmith
5	johnsmith
6	test3
7	kenx
8	kenx
9	kenx
10	kenx
11	kenx
12	kenx
13	kenx
14	kenx
15	user1
16	aero271
17	example
18	aero271
19	knex2
20	aero271
21	kenx
\.


--
-- Data for Name: friendships; Type: TABLE DATA; Schema: public; Owner: dbuser
--

COPY public.friendships (id, time_added, user_1, user_2) FROM stdin;
1	2025-01-10 23:53:01.026471	13	14
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: dbuser
--

COPY public.messages (id, content, user_id, chat_id, time_sent) FROM stdin;
1	this is a message	1	1	2024-12-26 20:58:19.19443
2	asdasd	14	14	2024-12-26 21:14:48.801468
3	asd	14	14	2024-12-26 21:28:04.948655
4	kdopaskdasop	14	14	2024-12-26 21:28:08.35201
5	this	14	14	2024-12-26 21:28:39.605015
6	is	14	14	2024-12-26 21:28:41.901062
7	possibly	14	14	2024-12-26 21:28:44.053014
8	woking	14	14	2024-12-26 21:28:46.284967
9	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaWQWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW	14	14	2024-12-26 21:28:55.67704
10	it appears	14	14	2024-12-26 21:29:01.936649
11	that 	14	14	2024-12-26 21:29:04.294751
12	long messagse go off the scvreen	14	14	2024-12-26 21:29:10.036571
13	im	14	14	2024-12-26 21:29:11.564658
14	just	14	14	2024-12-26 21:29:13.180063
15	it appears	14	14	2024-12-26 21:29:19.204056
16	that	14	14	2024-12-26 21:29:24.42036
17	the	14	14	2024-12-26 21:29:28.360524
18	nvm i fixed it	14	14	2024-12-26 21:34:14.205919
19	dsadas	14	19	2024-12-26 21:37:50.588573
20	alisdh	18	19	2024-12-26 21:37:59.327114
21	asdas	14	14	2024-12-27 02:37:02.322584
22	dasds	14	14	2024-12-27 02:39:30.36029
23	a	14	14	2024-12-27 02:39:43.156681
24	adasd	14	14	2024-12-27 02:40:20.591782
25	a	14	14	2024-12-27 02:40:38.195797
26	asdas	14	14	2024-12-27 02:49:18.1585
27	asdas	14	14	2024-12-27 02:52:36.340152
28	asdas	14	14	2024-12-27 02:53:38.188471
29	asda	14	14	2024-12-27 02:57:51.238147
30	aa	14	14	2024-12-27 02:57:55.68768
31	asd	14	14	2024-12-27 03:03:10.181711
32	as	19	20	2024-12-27 03:03:51.522387
33	asd	14	16	2024-12-27 03:04:42.974209
34	asdas	19	20	2024-12-27 03:04:56.355236
35	asda	14	14	2025-01-03 16:24:04.9111
36	asd	14	14	2025-01-03 16:36:25.018962
37	asd	14	14	2025-01-03 16:36:57.609047
38	asdas	14	14	2025-01-03 16:37:49.674463
39	asd	14	14	2025-01-03 16:37:55.213125
40	asd	14	14	2025-01-03 16:45:47.65949
41	a	14	14	2025-01-03 16:45:55.318682
42	asd	14	14	2025-01-03 16:46:08.334923
43	asd	14	14	2025-01-03 20:41:34.745917
44	das	14	14	2025-01-03 20:42:13.920282
45	asd	14	14	2025-01-03 20:45:52.469504
46	a	14	14	2025-01-03 20:47:25.157628
47	asd	14	14	2025-01-03 20:54:29.112592
48	asd	14	14	2025-01-03 20:55:00.552747
49	asd	14	14	2025-01-03 20:57:38.891791
50	asda	14	14	2025-01-03 20:59:32.87676
51	asd	14	19	2025-01-03 21:02:58.301735
52	dsa	14	19	2025-01-03 21:03:05.051974
53	asd	14	19	2025-01-03 21:12:41.181927
54	asd	14	19	2025-01-03 21:13:53.218144
55	asd	14	19	2025-01-03 21:14:09.245121
56	asd	14	19	2025-01-03 21:14:38.630815
57	asd	14	19	2025-01-03 21:15:21.392727
58	that	14	19	2025-01-03 21:15:24.644707
59	was 	14	19	2025-01-03 21:15:25.274236
60	snappy	14	19	2025-01-03 21:15:27.085218
61	quite interesting	14	19	2025-01-03 21:16:03.084423
62	asd	14	19	2025-01-03 21:16:40.773482
63	asd	14	19	2025-01-03 21:17:37.51761
64	asd	14	19	2025-01-03 21:17:38.881798
65	asd	14	19	2025-01-03 21:17:39.42094
66	asd	14	19	2025-01-03 21:17:39.597449
67	as	14	19	2025-01-03 21:17:39.750064
68	d	14	19	2025-01-03 21:17:39.92091
69	asd	14	19	2025-01-05 01:59:37.757692
70	a	14	19	2025-01-05 02:02:36.714804
71	a	14	19	2025-01-05 02:08:15.248878
72	asdsa	14	19	2025-01-05 02:08:16.427613
73	asd	14	14	2025-01-06 16:40:59.508925
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: dbuser
--

COPY public.users (id, username, password) FROM stdin;
1	johnsmith	password
2	johnsmith1	password
3	johnsmith2	password
4	johnsmith3	password
6	example	password
8	example1	password
10	exampleuser	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
12	user1	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
13	kenx	2480346fc547677b375046cf57f4fdc5b6815e110cb1bca77858fa242e034bc7
14	aero271	46b31344878cad97276b6ea17c08c4fd60b7b22a8179649118e60f18a43f441f
15	test3	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
16	kenx 	2480346fc547677b375046cf57f4fdc5b6815e110cb1bca77858fa242e034bc7
17	 	36a9e7f1c95b82ffb99743e0c5c4ce95d83c9a430aac59f84ef3cbfab6145068
18	knex2	43d23283a280786f3daf44a1f6564d8430644c9588556753db596d5a470926e4
19	testtttt	ed02457b5c41d964dbd2f2a609d63fe1bb7528dbe55e1abf5b52c249cd735797
\.


--
-- Data for Name: users_chats; Type: TABLE DATA; Schema: public; Owner: dbuser
--

COPY public.users_chats (user_id, chat_id, date_joined) FROM stdin;
12	1	2024-12-19
12	2	2024-12-19
1	1	2024-12-21
13	9	2024-12-21
13	10	2024-12-21
13	11	2024-12-21
13	12	2024-12-22
12	12	2024-12-22
13	13	2024-12-22
12	13	2024-12-22
13	14	2024-12-23
14	14	2024-12-23
12	15	2024-12-23
14	15	2024-12-23
14	16	2024-12-23
15	16	2024-12-23
6	17	2024-12-24
16	17	2024-12-24
14	18	2024-12-25
17	18	2024-12-25
18	19	2024-12-26
14	19	2024-12-26
14	20	2024-12-27
19	20	2024-12-27
13	21	2025-01-09
\.


--
-- Name: chats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbuser
--

SELECT pg_catalog.setval('public.chats_id_seq', 21, true);


--
-- Name: friendships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbuser
--

SELECT pg_catalog.setval('public.friendships_id_seq', 1, true);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbuser
--

SELECT pg_catalog.setval('public.messages_id_seq', 73, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbuser
--

SELECT pg_catalog.setval('public.users_id_seq', 21, true);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: users unique_user; Type: CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_user UNIQUE (username);


--
-- Name: users_chats users_chats_pkey; Type: CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.users_chats
    ADD CONSTRAINT users_chats_pkey PRIMARY KEY (user_id, chat_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_user_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_user_1_fkey FOREIGN KEY (user_1) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: friendships friendships_user_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_user_2_fkey FOREIGN KEY (user_2) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- Name: messages messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users_chats users_chats_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.users_chats
    ADD CONSTRAINT users_chats_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- Name: users_chats users_chats_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbuser
--

ALTER TABLE ONLY public.users_chats
    ADD CONSTRAINT users_chats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO dbuser;


--
-- PostgreSQL database dump complete
--

