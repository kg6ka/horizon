--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.signersaccount;
DROP INDEX public.sellingissuerindex;
DROP INDEX public.priceindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.histfeebyseq;
DROP INDEX public.histbyseq;
DROP INDEX public.buyingissuerindex;
DROP INDEX public.accountbalances;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.txfeehistory DROP CONSTRAINT txfeehistory_pkey;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.pubsub DROP CONSTRAINT pubsub_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.txfeehistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.pubsub;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(56) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(56),
    homedomain character varying(32) NOT NULL,
    thresholds text NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= 0)),
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    bucketlisthash character(64) NOT NULL,
    ledgerseq integer,
    closetime bigint NOT NULL,
    data text NOT NULL,
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    sellerid character varying(56) NOT NULL,
    offerid bigint NOT NULL,
    sellingassettype integer NOT NULL,
    sellingassetcode character varying(12),
    sellingissuer character varying(56),
    buyingassettype integer NOT NULL,
    buyingassetcode character varying(12),
    buyingissuer character varying(56),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price double precision NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
    CONSTRAINT offers_amount_check CHECK ((amount >= 0)),
    CONSTRAINT offers_offerid_check CHECK ((offerid >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character varying(15) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535)))
);


--
-- Name: pubsub; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pubsub (
    resid character(32) NOT NULL,
    lastread integer
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(56) NOT NULL,
    publickey character varying(56) NOT NULL,
    weight integer NOT NULL
);


--
-- Name: storestate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storestate (
    statename character(32) NOT NULL,
    state text
);


--
-- Name: trustlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trustlines (
    accountid character varying(56) NOT NULL,
    assettype integer NOT NULL,
    issuer character varying(56) NOT NULL,
    assetcode character varying(12) NOT NULL,
    tlimit bigint NOT NULL,
    balance bigint NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit > 0))
);


--
-- Name: txfeehistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txfeehistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txchanges text NOT NULL,
    CONSTRAINT txfeehistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags, lastmodified) FROM stdin;
GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H	999999994999999500	5	0	\N		AQAAAA==	0	2
GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2	999999900	8589934593	1	\N		AQAAAA==	0	3
GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	999999800	8589934594	0	\N		AQAAAA==	0	4
GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	999999800	8589934594	0	\N		AQAAAA==	0	4
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	999999700	8589934595	3	\N		AQAAAA==	0	5
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	999999800	8589934594	1	\N		AQAAAA==	0	6
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
63d98f536ee68d1b27b5b89f23af5311b7569a24faf1403ad0b52b633b07be99	0000000000000000000000000000000000000000000000000000000000000000	572a2e32ff248a07b0e70fd1f6d318c1facd20b6cc08c33d5775259868125a16	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABXKi4y/ySKB7DnD9H20xjB+s0gtswIwz1XdSWYaBJaFgAAAAEN4Lazp2QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZAX14QAAAABkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
fbf361e7685e448402a5038f45546f50e3fd0a4e04bb1fc05c7a9b4e8a909b80	63d98f536ee68d1b27b5b89f23af5311b7569a24faf1403ad0b52b633b07be99	29da0928d9a60e8f21bd58d97a0801e8339d4ac4914af60d283ae2f792cf225e	2	1444259272	AAAAAWPZj1Nu5o0bJ7W4nyOvUxG3Vpok+vFAOtC1K2M7B76ZhnfbEDpHPYd45nQcT7XkfIMwSX9gFD9+fWat716QIWcAAAAAVhWlyAAAAAIAAAAIAAAAAQAAAAEAAAAIAAAAAwAAAfQAAAAAQ9m8LSG8b5W0buxEtqstVQz7IV/HrDmGEtdA4mCEDXwp2gko2aYOjyG9WNl6CAHoM51KxJFK9g0oOuL3ks8iXgAAAAIN4Lazp2QAAAAAAAAAAAH0AAAAAAAAAAAAAAAAAAAAZAX14QAAAAH0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
6c02adc12181de4f35f6a1b6bae203f529e94e34ffd29ad10cc88e92c8d62359	fbf361e7685e448402a5038f45546f50e3fd0a4e04bb1fc05c7a9b4e8a909b80	b71466e9ecc6b40c0a6795f28b3c9d5a51ea4be1487bd76435bed1a85027f798	3	1444259273	AAAAAfvzYedoXkSEAqUDj0VUb1Dj/QpOBLsfwFx6m06KkJuAU/ZuXmatGe2HKEnEz0iF1isEBjs7N+k5cW8QYAiWwKIAAAAAVhWlyQAAAAAAAAAAxH0sg6vOAMny7YbV/FRscczh18GVQR9oJGYXQmDe6RO3FGbp7Ma0DApnlfKLPJ1aUepL4Uh712Q1vtGoUCf3mAAAAAMN4Lazp2QAAAAAAAAAAAOEAAAAAAAAAAAAAAAAAAAAZAX14QAAAAH0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
31865387277ad378b20d985c697c9fc65b5a507632e2d7d7c4a3018bb0a0e0be	6c02adc12181de4f35f6a1b6bae203f529e94e34ffd29ad10cc88e92c8d62359	29f11f2d7e9f05ec5b7880c707ba98bfd21f80213b408b2a2a782971b0c92663	4	1444259274	AAAAAWwCrcEhgd5PNfahtrriA/Up6U40/9Ka0QzIjpLI1iNZ5PhULA3h9sgbVtfBs1AIPcqATqiXvkWmO86rflbk1ywAAAAAVhWlygAAAAAAAAAAsi9a21jqDRD4i/XHyj+xRSVgYcx7Ecx56J32RnrNw/gp8R8tfp8F7Ft4gMcHupi/0h+AITtAiyoqeClxsMkmYwAAAAQN4Lazp2QAAAAAAAAAAAUUAAAAAAAAAAAAAAAAAAAAZAX14QAAAAH0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
fcab6ea5b32374e0f97430c6173599bcbf31834348c9e4115bd490a807270bec	31865387277ad378b20d985c697c9fc65b5a507632e2d7d7c4a3018bb0a0e0be	22cd6cf5481e62f175fe32d77ea78c5b21bd003f9b4f9d54c6963d49a4332fe6	5	1444259275	AAAAATGGU4cnetN4sg2YXGl8n8ZbWlB2MuLX18SjAYuwoOC+qxUDM4UUE4jBOFL1vOJK9zpfRnjFyjUX/bGrYNAxansAAAAAVhWlywAAAAAAAAAAMipVgDbLOBwRolHBsTSsmxFNzeTX3AdqZSXt3LGMFmgizWz1SB5i8XX+Mtd+p4xbIb0AP5tPnVTGlj1JpDMv5gAAAAUN4Lazp2QAAAAAAAAAAAV4AAAAAAAAAAAAAAABAAAAZAX14QAAAAH0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
b00d7c472f725ee658853cdfa8da1799944a532f705b6b072adeafd524f990a4	fcab6ea5b32374e0f97430c6173599bcbf31834348c9e4115bd490a807270bec	8e23e486ad7af468e40ba62570036ef2a01c751175425b1bcc7867a0f02723da	6	1444259276	AAAAAfyrbqWzI3Tg+XQwxhc1mby/MYNDSMnkEVvUkKgHJwvsLOJBkcTWKB+zQU13b+uR7kbdG4ZSVTkiu+l7eUfGQsgAAAAAVhWlzAAAAAAAAAAAdopGqZ/Fgz8xg91fCwTsvxIms9ukW73CHeCtBuNmNWKOI+SGrXr0aOQLpiVwA27yoBx1EXVCWxvMeGeg8Ccj2gAAAAYN4Lazp2QAAAAAAAAAAAXcAAAAAAAAAAAAAAABAAAAZAX14QAAAAH0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (sellerid, offerid, sellingassettype, sellingassetcode, sellingissuer, buyingassettype, buyingassetcode, buyingissuer, amount, pricen, priced, price, flags, lastmodified) FROM stdin;
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	1	1	EUR	GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	1	USD	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	100000000	1	1	1	0	6
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures) FROM stdin;
\.


--
-- Data for Name: pubsub; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pubsub (resid, lastread) FROM stdin;
\.


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY signers (accountid, publickey, weight) FROM stdin;
\.


--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY storestate (statename, state) FROM stdin;
databaseinitialized             	true
forcescponnextlaunch            	false
lastclosedledger                	b00d7c472f725ee658853cdfa8da1799944a532f705b6b072adeafd524f990a4
historyarchivestate             	{\n    "version": 1,\n    "server": "v0.1-7-gd6ebc57-dirty",\n    "currentLedger": 6,\n    "currentBuckets": [\n        {\n            "curr": "79391bf33fd5a341423586995f9a6dde843260f83f346968e9cdb9977fde02f0",\n            "next": {\n                "state": 0\n            },\n            "snap": "ec19f2b1d645e88d0ba56af0d6b0f3f20ff06d14e70a910b0e6036e2bf86a884"\n        },\n        {\n            "curr": "73fc208cc0751e60e9ccc917a94a05106cf329863e0a3a0b13f88f8f8d53ad30",\n            "next": {\n                "state": 1,\n                "output": "ec19f2b1d645e88d0ba56af0d6b0f3f20ff06d14e70a910b0e6036e2bf86a884"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, assettype, issuer, assetcode, tlimit, balance, flags, lastmodified) FROM stdin;
GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2	1	GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	EUR	9223372036854775807	1100000000	1	6
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	USD	9223372036854775807	300000000	1	6
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	1	GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	EUR	9223372036854775807	100000000	1	6
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	USD	9223372036854775807	900000000	1	6
\.


--
-- Data for Name: txfeehistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txfeehistory (txid, ledgerseq, txindex, txchanges) FROM stdin;
666656a6eade2082c5780571267d9e4453eee5781ca9a58aa319eb0fe83455fd	2	1	AAAAAQAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/+cAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
b1f828384c56e4b024f4275f246580ababff1ae3b9ba61b03897357e57eebc20	2	2	AAAAAQAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/84AAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
2b2e82dbabb024b27a0c3140ca71d8ac9bc71831f9f5a3bd69eca3d88fb0ec5c	2	3	AAAAAQAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/7UAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
e17bae552da0105ad32f0b9aadfd0f623ef37eb486b10b044c19238360e455d7	2	4	AAAAAQAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/5wAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
cfd8816ed587c5ed88dea0eb00818caf38c0750e7740e05de3c27176e9aee8ee	2	5	AAAAAQAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/4MAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
b5cadce05fc0ad5d6fe009b8b0debc0d3dfd32ea42b8eba3e9ea68c2746e410f	3	1	AAAAAQAAAAEAAAADAAAAAAAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAA7msmcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
811192c38643df73c015a5a1d77b802dff05d4f50fc6d10816aa75c0a6109f9a	3	2	AAAAAQAAAAEAAAADAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAA7msmcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
bd486dbdd02d460817671c4a5a7e9d6e865ca29cb41e62d7aaf70a2fee5b36de	3	3	AAAAAQAAAAEAAAADAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAA7msmcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
32e4ba1f218b6aa2420b497456a1b09090e3837e66b3495030d4edd60d0f0570	3	4	AAAAAQAAAAEAAAADAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAA7msk4AAAAAgAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
7736f0b869de0f74a5ed7f8d6529949238eb0f0421f3fc2bbc438084f21c8055	4	1	AAAAAQAAAAEAAAAEAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAA7msmcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
09c0147a62c828321ee899d0cccd92c81525eea71250720260321b3a24995e8b	4	2	AAAAAQAAAAEAAAAEAAAAAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAA7msmcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
c93f80667f37df70a29ec0de96ff3381644ac828a4cea1cb6ceb1bcec6fff058	4	3	AAAAAQAAAAEAAAAEAAAAAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAA7msk4AAAAAgAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
f74cd54800d537c06dff35cc4783be881c2d670c1151a56ca7f951758dc7415d	4	4	AAAAAQAAAAEAAAAEAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAA7msk4AAAAAgAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
b52f16ffb98c047e33b9c2ec30880330cde71f85b3443dae2c5cb86c7d4d8452	5	1	AAAAAQAAAAEAAAAFAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAA7msjUAAAAAgAAAAMAAAACAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
1d2a4be72470658f68db50eef29ea0af3f985ce18b5c218f03461d40c47dc292	6	1	AAAAAQAAAAEAAAAGAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAA7msk4AAAAAgAAAAIAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
666656a6eade2082c5780571267d9e4453eee5781ca9a58aa319eb0fe83455fd	2	1	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAO5rKAAAAAAAAAAABVvwF9wAAAEBdDXe23U4e9C2SxpBLZRx1rJzSFLJ0xDD0uKGpmqbflDT+XXIq6UiDBzmFxt+GO+XqFoQPdrXT7p1oLZIHqTMP	ZmZWpureIILFeAVxJn2eRFPu5XgcqaWKoxnrD+g0Vf0AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2s2vJNAwAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
b1f828384c56e4b024f4275f246580ababff1ae3b9ba61b03897357e57eebc20	2	2	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAACAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAO5rKAAAAAAAAAAABVvwF9wAAAEBdfnFSzZeh17zt82oMdqe4+/xns/kHBdGXf9BIBRYfVZ3DQT3awwZn5LqgIG9JqlvMmR1TKaxcoJQDuqGcCScM	sfgoOExW5LAk9CdfJGWAq6v/GuO5umGwOJc1flfuvCAAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2szAuagwAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
2b2e82dbabb024b27a0c3140ca71d8ac9bc71831f9f5a3bd69eca3d88fb0ec5c	2	3	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAADAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rKAAAAAAAAAAABVvwF9wAAAEDJul1tLGLF4Vxwt0dDCVEf6tb5l4byMrGgCp+lVZMmxct54iNf2mxtjx6Md5ZJ4E4Dlcsf46EAhBGSUPsn8fYD	Ky6C26uwJLJ6DDFAynHYrJvHGDH59aO9aeyj2I+w7FwAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2svSToAwAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
e17bae552da0105ad32f0b9aadfd0f623ef37eb486b10b044c19238360e455d7	2	4	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAAAO5rKAAAAAAAAAAABVvwF9wAAAEDYYfyOrmPhfki6lrP+oCfunJmRu2mfxl40o5qWR7y1YmP8poG+6Xqg41jKCWNwVoP717CVEPe70I0teWvTejkJ	4XuuVS2gEFrTLwuarf0PYj7zfrSGsQsETBkjg2DkVdcAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2srj41gwAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
cfd8816ed587c5ed88dea0eb00818caf38c0750e7740e05de3c27176e9aee8ee	2	5	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAO5rKAAAAAAAAAAABVvwF9wAAAEDNmQhdQeyMcWFWP8dVRkDtFS4tHICyKdaPkR6+/L7+tMzKWoUjbDAXscRYI+j6Fd/VFUaDzdYsWCAsH30WujIL	z9iBbtWHxe2I3qDrAIGMrzjAdQ53QOBd48Jxdumu6O4AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2sn1eDAwAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
b5cadce05fc0ad5d6fe009b8b0debc0d3dfd32ea42b8eba3e9ea68c2746e410f	3	1	AAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSX//////////AAAAAAAAAAEnciLVAAAAQANQSzvpEBCAXvs1PgmH/UFbfAYt3OAggYPVTd0pjVcJaV3lDE/jOZMnLFZMkFEhg4dluVQxeDZAwTKUPandswg=	tcrc4F/ArV1v4Am4sN68DT39MupCuOuj6epownRuQQ8AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAMAAAABAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAAAAAAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAMAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAADuayZwAAAACAAAAAQAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
811192c38643df73c015a5a1d77b802dff05d4f50fc6d10816aa75c0a6109f9a	3	2	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAFvFIhaAAAAQPlg7GLhJg0x7jpAw1Ew6H2XF6yRImfJIwFfx09Nui5btOJAFewFANfOaAB8FQZl5p3A5g3k6DHDigfUNUD16gc=	gRGSw4ZD33PAFaWh13uALf8F1PUPxtEIFqp1wKYQn5oAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAMAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAMAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAADuayTgAAAACAAAAAgAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
bd486dbdd02d460817671c4a5a7e9d6e865ca29cb41e62d7aaf70a2fee5b36de	3	3	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAGu5L5MAAAAQB9kmKW2q3v7Qfy8PMekEb1TTI5ixqkI0BogXrOt7gO162Qbkh2dSTUfeDovc0PAafhDXxthVAlsLujlBmyjBAY=	vUhtvdAtRggXZxxKWn6dboZcopy0HmLXqvcKL+5bNt4AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAMAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAMAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADuayZwAAAACAAAAAQAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
32e4ba1f218b6aa2420b497456a1b09090e3837e66b3495030d4edd60d0f0570	3	4	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAZAAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSX//////////AAAAAAAAAAFvFIhaAAAAQMJmv+lhF5QZlgdIqBXDSdhEtgraTrRSwVr5d/BrNC28efHMoxYNa+2u9tSEdxU+hGX6JRW7wAF3bOpA8rxxxAE=	MuS6HyGLaqJCC0l0VqGwkJDjg35ms0lQMNTt1g0PBXAAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAACAAAAAAAAAAMAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAAAAAAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAMAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAADuayTgAAAACAAAAAgAAAAIAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
7736f0b869de0f74a5ed7f8d6529949238eb0f0421f3fc2bbc438084f21c8055	4	1	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAA7msoAAAAAAAAAAAH5kC3vAAAAQDjBSAulKc9tRqGg+OkVbKPz4olRQYUevyCfv0LAlqbXG6yPbpR0BR6o7mrimRm8O4VoRBGIATQB42NOWcFzdQw=	dzbwuGneD3Sl7X+NZSmUkjjrDwQh8/wrvEOAhPIcgFUAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAQAAAAQAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAO5rKAH//////////AAAAAQAAAAAAAAAA
09c0147a62c828321ee899d0cccd92c81525eea71250720260321b3a24995e8b	4	2	AAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAAL68IAAAAAAAAAAAEQithJAAAAQCaHhpiVN9E437IXFcHpfVrox1SO/NJtCmB2hgagMQHDRDGQMHN3qjScTOqqeEsNEuvK+n7I4b+9Fr0R3twmcgs=	CcAUemLIKDIe6JnQzM2SyBUl7qcSUHICYDIbOiSZXosAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAQAAAAQAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAC+vCAH//////////AAAAAQAAAAAAAAAA
c93f80667f37df70a29ec0de96ff3381644ac828a4cea1cb6ceb1bcec6fff058	4	3	AAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAZAAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAA7msoAAAAAAAAAAAEQithJAAAAQG4l7kCAq5aqvS2d/HTtYc7LAa7pSUiiO4KyKJbqmsDgvckGC2dbhcro9tcvCZHfwqTV+ikv8Hm8Zfa63kYPkQY=	yT+AZn8333CinsDelv8zgWRKyCikzqHLbOsbzsb/8FgAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAQAAAAQAAAABAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAO5rKAH//////////AAAAAQAAAAAAAAAA
f74cd54800d537c06dff35cc4783be881c2d670c1151a56ca7f951758dc7415d	4	4	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAZAAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAL68IAAAAAAAAAAAH5kC3vAAAAQOIKSlDQm9Urq2ujnvxZjGq6zJQncPTp8vl4sCC4Ra4MUnaHYDakRXTFoQlIFAr5t0oJwdBSs6TJ8M5VeGgBbQg=	90zVSADVN8Bt/zXMR4O+iBwtZwwRUaVsp/lRdY3HQV0AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAQAAAAQAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAC+vCAH//////////AAAAAQAAAAAAAAAA
b52f16ffb98c047e33b9c2ec30880330cde71f85b3443dae2c5cb86c7d4d8452	5	1	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAZAAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAvrwgAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAFvFIhaAAAAQFlXwaom7ylSTdyaO7qNM74Y+JUkA2o0uc7W2FzBlkVe2scznMMa+R8hVTblO5lQ6+FcTM5jIrWQqxqFFZbOkAw=	tS8W/7mMBH4zucLsMIgDMM3nH4WzRD2uLFy4bH1NhFIAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAAAQAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAC+vCAAAAAAEAAAABAAAAAAAAAAAAAAAA	AAAAAAAAAAEAAAACAAAAAAAAAAUAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAEAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAvrwgAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAEAAAAFAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAA7msjUAAAAAgAAAAMAAAADAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
1d2a4be72470658f68db50eef29ea0af3f985ce18b5c218f03461d40c47dc292	6	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAZAAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAIAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAF9eEAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAABfXhAAAAAAAAAAAAAAAAAa7kvkwAAABAD49aRUuzXXeNHu1FfIYBbplBoP+b1B4uMGt2UGZt6jPKvwVORmMzfXDZaHBvIirsI8eNf+9F1EI0Fh9M/2jmCg==	HSpL5yRwZY9o21Du8p6grz+YXOGLXCGPA0YdQMR9wpIAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAIAAAAAAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAABAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAABfXhAAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAX14QAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAAF9eEAAAAAAA==	AAAAAAAAAAEAAAAFAAAAAQAAAAYAAAABAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAQZCrAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAYAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAABfXhAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAYAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAEeGjAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAYAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAANaTpAH//////////AAAAAQAAAAAAAAAAAAAAAQAAAAYAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAEAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAX14QAAAAABAAAAAQAAAAAAAAAAAAAAAA==
\.


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (accountid);


--
-- Name: ledgerheaders_ledgerseq_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_ledgerseq_key UNIQUE (ledgerseq);


--
-- Name: ledgerheaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (ledgerhash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offerid);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


--
-- Name: pubsub_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pubsub
    ADD CONSTRAINT pubsub_pkey PRIMARY KEY (resid);


--
-- Name: signers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signers
    ADD CONSTRAINT signers_pkey PRIMARY KEY (accountid, publickey);


--
-- Name: storestate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storestate
    ADD CONSTRAINT storestate_pkey PRIMARY KEY (statename);


--
-- Name: trustlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trustlines
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, assetcode);


--
-- Name: txfeehistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txfeehistory
    ADD CONSTRAINT txfeehistory_pkey PRIMARY KEY (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (ledgerseq, txindex);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance) WHERE (balance >= 1000000000);


--
-- Name: buyingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX buyingissuerindex ON offers USING btree (buyingissuer);


--
-- Name: histbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX histbyseq ON txhistory USING btree (ledgerseq);


--
-- Name: histfeebyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX histfeebyseq ON txfeehistory USING btree (ledgerseq);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: sellingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sellingissuerindex ON offers USING btree (sellingissuer);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- PostgreSQL database dump complete
--

