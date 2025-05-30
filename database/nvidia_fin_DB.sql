--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

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

DROP DATABASE nvidia;
--
-- Name: nvidia; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE nvidia WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'fr-FR';


ALTER DATABASE nvidia OWNER TO postgres;

\connect nvidia

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
-- Name: activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activities (
    activity_id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE public.activities OWNER TO postgres;

--
-- Name: activities_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activities_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activities_activity_id_seq OWNER TO postgres;

--
-- Name: activities_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activities_activity_id_seq OWNED BY public.activities.activity_id;


--
-- Name: quarterly_financials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quarterly_financials (
    yq_id integer NOT NULL,
    revenue integer NOT NULL,
    operating_income integer NOT NULL,
    net_income integer NOT NULL,
    gross_margin_percentage numeric(4,2) NOT NULL,
    taxes_and_interests integer,
    cost_of_goods_sold integer,
    gross_profit integer,
    operating_expenses integer,
    cogs_opex_difference integer
);


ALTER TABLE public.quarterly_financials OWNER TO postgres;

--
-- Name: quarterly_revenue_per_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quarterly_revenue_per_activity (
    yq_id integer NOT NULL,
    activity_id integer NOT NULL,
    ammount integer NOT NULL
);


ALTER TABLE public.quarterly_revenue_per_activity OWNER TO postgres;

--
-- Name: quarters_per_year; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quarters_per_year (
    yq_id integer NOT NULL,
    quarter integer NOT NULL,
    year integer NOT NULL
);


ALTER TABLE public.quarters_per_year OWNER TO postgres;

--
-- Name: quarters_per_year_yq_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quarters_per_year_yq_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quarters_per_year_yq_id_seq OWNER TO postgres;

--
-- Name: quarters_per_year_yq_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quarters_per_year_yq_id_seq OWNED BY public.quarters_per_year.yq_id;


--
-- Name: shares_numbers_in_million; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shares_numbers_in_million (
    year integer NOT NULL,
    treasury_stock numeric(11,4),
    total_outstanding numeric(11,4),
    insiders numeric(11,4),
    institutions_top_3 numeric(11,4),
    rest numeric(11,4)
);


ALTER TABLE public.shares_numbers_in_million OWNER TO postgres;

--
-- Name: valuations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.valuations (
    year integer NOT NULL,
    equity_value_per_share numeric(5,2),
    average_market_cap integer,
    enterprise_value integer
);


ALTER TABLE public.valuations OWNER TO postgres;

--
-- Name: yearly_financials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yearly_financials (
    year integer NOT NULL,
    revenue integer NOT NULL,
    operating_income integer NOT NULL,
    net_income integer NOT NULL,
    gross_margin_percentage numeric(4,2) NOT NULL,
    taxes_and_interests integer,
    cost_of_goods_sold integer,
    gross_profit integer,
    operating_expenses integer NOT NULL,
    cogs_opex_difference integer
);


ALTER TABLE public.yearly_financials OWNER TO postgres;

--
-- Name: yearly_financials_extra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yearly_financials_extra (
    year integer NOT NULL,
    total_assets integer,
    total_liabilities integer,
    total_debt integer,
    cash_and_cash_equivalents integer,
    net_debt integer,
    average_stock_price numeric(7,3),
    depreciation_and_amortization integer
);


ALTER TABLE public.yearly_financials_extra OWNER TO postgres;

--
-- Name: yearly_revenue_per_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yearly_revenue_per_activity (
    year integer NOT NULL,
    activity_id integer NOT NULL,
    ammount integer NOT NULL
);


ALTER TABLE public.yearly_revenue_per_activity OWNER TO postgres;

--
-- Name: activities activity_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities ALTER COLUMN activity_id SET DEFAULT nextval('public.activities_activity_id_seq'::regclass);


--
-- Name: quarters_per_year yq_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarters_per_year ALTER COLUMN yq_id SET DEFAULT nextval('public.quarters_per_year_yq_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.activities VALUES (1, 'Gaming');
INSERT INTO public.activities VALUES (2, 'Data Center');
INSERT INTO public.activities VALUES (3, 'ProViz');
INSERT INTO public.activities VALUES (4, 'Auto');
INSERT INTO public.activities VALUES (5, 'OEM & Other');


--
-- Data for Name: quarterly_financials; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quarterly_financials VALUES (1, 3207, 1295, 1244, 64.50, 51, 1138, 2069, 773, -365);
INSERT INTO public.quarterly_financials VALUES (2, 3123, 1157, 1101, 63.60, 56, 1137, 1986, 818, -319);
INSERT INTO public.quarterly_financials VALUES (3, 3181, 1058, 1230, 60.40, -172, 1260, 1921, 863, -397);
INSERT INTO public.quarterly_financials VALUES (4, 2205, 294, 567, 54.70, -273, 999, 1206, 913, -86);
INSERT INTO public.quarterly_financials VALUES (5, 2220, 358, 394, 58.40, -36, 924, 1296, 938, 14);
INSERT INTO public.quarterly_financials VALUES (6, 2579, 571, 552, 59.80, 19, 1037, 1542, 970, -67);
INSERT INTO public.quarterly_financials VALUES (7, 3014, 927, 899, 63.60, 28, 1097, 1917, 989, -108);
INSERT INTO public.quarterly_financials VALUES (8, 3105, 990, 950, 64.90, 40, 1090, 2015, 1025, -65);
INSERT INTO public.quarterly_financials VALUES (9, 3080, 976, 917, 65.10, 59, 1075, 2005, 1028, -47);
INSERT INTO public.quarterly_financials VALUES (10, 3866, 651, 622, 58.80, 29, 1593, 2273, 1624, 31);
INSERT INTO public.quarterly_financials VALUES (11, 4726, 1398, 1336, 62.60, 62, 1768, 2958, 1562, -206);
INSERT INTO public.quarterly_financials VALUES (12, 5003, 1507, 1457, 63.10, 50, 1846, 3157, 1650, -196);
INSERT INTO public.quarterly_financials VALUES (13, 5661, 1956, 1912, 64.10, 44, 2032, 3629, 1673, -359);
INSERT INTO public.quarterly_financials VALUES (14, 6507, 2444, 2374, 64.80, 70, 2290, 4217, 1771, -519);
INSERT INTO public.quarterly_financials VALUES (15, 7103, 2671, 2464, 65.20, 207, 2472, 4631, 1960, -512);
INSERT INTO public.quarterly_financials VALUES (16, 7643, 2970, 3003, 65.40, -33, 2644, 4999, 2029, -615);
INSERT INTO public.quarterly_financials VALUES (17, 8288, 1868, 1618, 65.50, 250, 2859, 5429, 3563, 704);
INSERT INTO public.quarterly_financials VALUES (18, 6704, 499, 656, 43.50, -157, 3788, 2916, 2416, -1372);
INSERT INTO public.quarterly_financials VALUES (19, 5931, 601, 680, 53.60, -79, 2752, 3179, 2576, -176);
INSERT INTO public.quarterly_financials VALUES (20, 6051, 1257, 1414, 63.30, -157, 2221, 3830, 2576, 355);
INSERT INTO public.quarterly_financials VALUES (21, 7192, 2140, 2043, 64.60, 97, 2546, 4646, 2508, -38);
INSERT INTO public.quarterly_financials VALUES (22, 13507, 6800, 6188, 70.10, 612, 4039, 9468, 2662, -1377);
INSERT INTO public.quarterly_financials VALUES (23, 18120, 10417, 9243, 74.00, 1174, 4711, 13409, 2983, -1728);
INSERT INTO public.quarterly_financials VALUES (24, 22103, 13615, 12285, 76.00, 1330, 5305, 16798, 3176, -2129);
INSERT INTO public.quarterly_financials VALUES (25, 26044, 16909, 14881, 78.40, 2028, 5626, 20418, 3497, -2129);
INSERT INTO public.quarterly_financials VALUES (26, 30040, 18642, 16599, 75.10, 2043, 7480, 22560, 3932, -3548);
INSERT INTO public.quarterly_financials VALUES (27, 35082, 21869, 19309, 74.60, 2560, 8911, 26171, 4287, -4624);
INSERT INTO public.quarterly_financials VALUES (28, 39331, 24034, 22091, 73.00, 1943, 10619, 28712, 4689, -5930);


--
-- Data for Name: quarterly_revenue_per_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quarterly_revenue_per_activity VALUES (1, 1, 1723);
INSERT INTO public.quarterly_revenue_per_activity VALUES (1, 3, 251);
INSERT INTO public.quarterly_revenue_per_activity VALUES (1, 2, 701);
INSERT INTO public.quarterly_revenue_per_activity VALUES (1, 4, 145);
INSERT INTO public.quarterly_revenue_per_activity VALUES (1, 5, 387);
INSERT INTO public.quarterly_revenue_per_activity VALUES (2, 1, 1805);
INSERT INTO public.quarterly_revenue_per_activity VALUES (2, 3, 281);
INSERT INTO public.quarterly_revenue_per_activity VALUES (2, 2, 760);
INSERT INTO public.quarterly_revenue_per_activity VALUES (2, 4, 161);
INSERT INTO public.quarterly_revenue_per_activity VALUES (2, 5, 116);
INSERT INTO public.quarterly_revenue_per_activity VALUES (3, 1, 1348);
INSERT INTO public.quarterly_revenue_per_activity VALUES (3, 3, 225);
INSERT INTO public.quarterly_revenue_per_activity VALUES (3, 2, 296);
INSERT INTO public.quarterly_revenue_per_activity VALUES (3, 4, 128);
INSERT INTO public.quarterly_revenue_per_activity VALUES (3, 5, 176);
INSERT INTO public.quarterly_revenue_per_activity VALUES (4, 1, 1027);
INSERT INTO public.quarterly_revenue_per_activity VALUES (4, 3, 205);
INSERT INTO public.quarterly_revenue_per_activity VALUES (4, 2, 401);
INSERT INTO public.quarterly_revenue_per_activity VALUES (4, 4, 140);
INSERT INTO public.quarterly_revenue_per_activity VALUES (4, 5, 156);
INSERT INTO public.quarterly_revenue_per_activity VALUES (5, 1, 1055);
INSERT INTO public.quarterly_revenue_per_activity VALUES (5, 3, 266);
INSERT INTO public.quarterly_revenue_per_activity VALUES (5, 2, 634);
INSERT INTO public.quarterly_revenue_per_activity VALUES (5, 4, 166);
INSERT INTO public.quarterly_revenue_per_activity VALUES (5, 5, 99);
INSERT INTO public.quarterly_revenue_per_activity VALUES (6, 1, 1313);
INSERT INTO public.quarterly_revenue_per_activity VALUES (6, 3, 191);
INSERT INTO public.quarterly_revenue_per_activity VALUES (6, 2, 655);
INSERT INTO public.quarterly_revenue_per_activity VALUES (6, 4, 209);
INSERT INTO public.quarterly_revenue_per_activity VALUES (6, 5, 111);
INSERT INTO public.quarterly_revenue_per_activity VALUES (7, 1, 1659);
INSERT INTO public.quarterly_revenue_per_activity VALUES (7, 3, 324);
INSERT INTO public.quarterly_revenue_per_activity VALUES (7, 2, 726);
INSERT INTO public.quarterly_revenue_per_activity VALUES (7, 4, 162);
INSERT INTO public.quarterly_revenue_per_activity VALUES (7, 5, 143);
INSERT INTO public.quarterly_revenue_per_activity VALUES (8, 1, 1491);
INSERT INTO public.quarterly_revenue_per_activity VALUES (8, 3, 331);
INSERT INTO public.quarterly_revenue_per_activity VALUES (8, 2, 968);
INSERT INTO public.quarterly_revenue_per_activity VALUES (8, 4, 163);
INSERT INTO public.quarterly_revenue_per_activity VALUES (8, 5, 152);
INSERT INTO public.quarterly_revenue_per_activity VALUES (9, 1, 1339);
INSERT INTO public.quarterly_revenue_per_activity VALUES (9, 3, 307);
INSERT INTO public.quarterly_revenue_per_activity VALUES (9, 2, 1141);
INSERT INTO public.quarterly_revenue_per_activity VALUES (9, 4, 155);
INSERT INTO public.quarterly_revenue_per_activity VALUES (9, 5, 138);
INSERT INTO public.quarterly_revenue_per_activity VALUES (10, 1, 1654);
INSERT INTO public.quarterly_revenue_per_activity VALUES (10, 3, 203);
INSERT INTO public.quarterly_revenue_per_activity VALUES (10, 2, 1752);
INSERT INTO public.quarterly_revenue_per_activity VALUES (10, 4, 111);
INSERT INTO public.quarterly_revenue_per_activity VALUES (10, 5, 146);
INSERT INTO public.quarterly_revenue_per_activity VALUES (11, 1, 2271);
INSERT INTO public.quarterly_revenue_per_activity VALUES (11, 3, 236);
INSERT INTO public.quarterly_revenue_per_activity VALUES (11, 2, 1900);
INSERT INTO public.quarterly_revenue_per_activity VALUES (11, 4, 125);
INSERT INTO public.quarterly_revenue_per_activity VALUES (11, 5, 194);
INSERT INTO public.quarterly_revenue_per_activity VALUES (12, 1, 2495);
INSERT INTO public.quarterly_revenue_per_activity VALUES (12, 3, 307);
INSERT INTO public.quarterly_revenue_per_activity VALUES (12, 2, 1903);
INSERT INTO public.quarterly_revenue_per_activity VALUES (12, 4, 145);
INSERT INTO public.quarterly_revenue_per_activity VALUES (12, 5, 153);
INSERT INTO public.quarterly_revenue_per_activity VALUES (13, 1, 2760);
INSERT INTO public.quarterly_revenue_per_activity VALUES (13, 3, 372);
INSERT INTO public.quarterly_revenue_per_activity VALUES (13, 2, 2048);
INSERT INTO public.quarterly_revenue_per_activity VALUES (13, 4, 154);
INSERT INTO public.quarterly_revenue_per_activity VALUES (13, 5, 327);
INSERT INTO public.quarterly_revenue_per_activity VALUES (14, 1, 3061);
INSERT INTO public.quarterly_revenue_per_activity VALUES (14, 3, 519);
INSERT INTO public.quarterly_revenue_per_activity VALUES (14, 2, 2366);
INSERT INTO public.quarterly_revenue_per_activity VALUES (14, 4, 152);
INSERT INTO public.quarterly_revenue_per_activity VALUES (14, 5, 409);
INSERT INTO public.quarterly_revenue_per_activity VALUES (15, 1, 3221);
INSERT INTO public.quarterly_revenue_per_activity VALUES (15, 3, 577);
INSERT INTO public.quarterly_revenue_per_activity VALUES (15, 2, 2936);
INSERT INTO public.quarterly_revenue_per_activity VALUES (15, 4, 135);
INSERT INTO public.quarterly_revenue_per_activity VALUES (15, 5, 234);
INSERT INTO public.quarterly_revenue_per_activity VALUES (16, 1, 3420);
INSERT INTO public.quarterly_revenue_per_activity VALUES (16, 3, 643);
INSERT INTO public.quarterly_revenue_per_activity VALUES (16, 2, 3263);
INSERT INTO public.quarterly_revenue_per_activity VALUES (16, 4, 125);
INSERT INTO public.quarterly_revenue_per_activity VALUES (16, 5, 192);
INSERT INTO public.quarterly_revenue_per_activity VALUES (17, 1, 3620);
INSERT INTO public.quarterly_revenue_per_activity VALUES (17, 3, 622);
INSERT INTO public.quarterly_revenue_per_activity VALUES (17, 2, 3750);
INSERT INTO public.quarterly_revenue_per_activity VALUES (17, 4, 138);
INSERT INTO public.quarterly_revenue_per_activity VALUES (17, 5, 158);
INSERT INTO public.quarterly_revenue_per_activity VALUES (18, 1, 2042);
INSERT INTO public.quarterly_revenue_per_activity VALUES (18, 3, 496);
INSERT INTO public.quarterly_revenue_per_activity VALUES (18, 2, 3806);
INSERT INTO public.quarterly_revenue_per_activity VALUES (18, 4, 220);
INSERT INTO public.quarterly_revenue_per_activity VALUES (18, 5, 140);
INSERT INTO public.quarterly_revenue_per_activity VALUES (19, 1, 3833);
INSERT INTO public.quarterly_revenue_per_activity VALUES (19, 3, 200);
INSERT INTO public.quarterly_revenue_per_activity VALUES (19, 2, 1574);
INSERT INTO public.quarterly_revenue_per_activity VALUES (19, 4, 251);
INSERT INTO public.quarterly_revenue_per_activity VALUES (19, 5, 73);
INSERT INTO public.quarterly_revenue_per_activity VALUES (20, 1, 3616);
INSERT INTO public.quarterly_revenue_per_activity VALUES (20, 3, 226);
INSERT INTO public.quarterly_revenue_per_activity VALUES (20, 2, 1831);
INSERT INTO public.quarterly_revenue_per_activity VALUES (20, 4, 294);
INSERT INTO public.quarterly_revenue_per_activity VALUES (20, 5, 84);
INSERT INTO public.quarterly_revenue_per_activity VALUES (21, 1, 4284);
INSERT INTO public.quarterly_revenue_per_activity VALUES (21, 3, 295);
INSERT INTO public.quarterly_revenue_per_activity VALUES (21, 2, 2240);
INSERT INTO public.quarterly_revenue_per_activity VALUES (21, 4, 296);
INSERT INTO public.quarterly_revenue_per_activity VALUES (21, 5, 77);
INSERT INTO public.quarterly_revenue_per_activity VALUES (22, 1, 2486);
INSERT INTO public.quarterly_revenue_per_activity VALUES (22, 3, 379);
INSERT INTO public.quarterly_revenue_per_activity VALUES (22, 2, 10323);
INSERT INTO public.quarterly_revenue_per_activity VALUES (22, 4, 253);
INSERT INTO public.quarterly_revenue_per_activity VALUES (22, 5, 66);
INSERT INTO public.quarterly_revenue_per_activity VALUES (23, 1, 2856);
INSERT INTO public.quarterly_revenue_per_activity VALUES (23, 3, 416);
INSERT INTO public.quarterly_revenue_per_activity VALUES (23, 2, 14514);
INSERT INTO public.quarterly_revenue_per_activity VALUES (23, 4, 261);
INSERT INTO public.quarterly_revenue_per_activity VALUES (23, 5, 73);
INSERT INTO public.quarterly_revenue_per_activity VALUES (24, 1, 2865);
INSERT INTO public.quarterly_revenue_per_activity VALUES (24, 3, 463);
INSERT INTO public.quarterly_revenue_per_activity VALUES (24, 2, 18404);
INSERT INTO public.quarterly_revenue_per_activity VALUES (24, 4, 281);
INSERT INTO public.quarterly_revenue_per_activity VALUES (24, 5, 90);
INSERT INTO public.quarterly_revenue_per_activity VALUES (25, 1, 2647);
INSERT INTO public.quarterly_revenue_per_activity VALUES (25, 3, 427);
INSERT INTO public.quarterly_revenue_per_activity VALUES (25, 2, 22563);
INSERT INTO public.quarterly_revenue_per_activity VALUES (25, 4, 329);
INSERT INTO public.quarterly_revenue_per_activity VALUES (25, 5, 78);
INSERT INTO public.quarterly_revenue_per_activity VALUES (26, 1, 2880);
INSERT INTO public.quarterly_revenue_per_activity VALUES (26, 3, 454);
INSERT INTO public.quarterly_revenue_per_activity VALUES (26, 2, 26272);
INSERT INTO public.quarterly_revenue_per_activity VALUES (26, 4, 346);
INSERT INTO public.quarterly_revenue_per_activity VALUES (26, 5, 88);
INSERT INTO public.quarterly_revenue_per_activity VALUES (27, 1, 3279);
INSERT INTO public.quarterly_revenue_per_activity VALUES (27, 3, 486);
INSERT INTO public.quarterly_revenue_per_activity VALUES (27, 2, 30771);
INSERT INTO public.quarterly_revenue_per_activity VALUES (27, 4, 449);
INSERT INTO public.quarterly_revenue_per_activity VALUES (27, 5, 97);
INSERT INTO public.quarterly_revenue_per_activity VALUES (28, 1, 2544);
INSERT INTO public.quarterly_revenue_per_activity VALUES (28, 3, 511);
INSERT INTO public.quarterly_revenue_per_activity VALUES (28, 2, 35580);
INSERT INTO public.quarterly_revenue_per_activity VALUES (28, 4, 570);
INSERT INTO public.quarterly_revenue_per_activity VALUES (28, 5, 126);


--
-- Data for Name: quarters_per_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quarters_per_year VALUES (1, 1, 2019);
INSERT INTO public.quarters_per_year VALUES (2, 2, 2019);
INSERT INTO public.quarters_per_year VALUES (3, 3, 2019);
INSERT INTO public.quarters_per_year VALUES (4, 4, 2019);
INSERT INTO public.quarters_per_year VALUES (5, 1, 2020);
INSERT INTO public.quarters_per_year VALUES (6, 2, 2020);
INSERT INTO public.quarters_per_year VALUES (7, 3, 2020);
INSERT INTO public.quarters_per_year VALUES (8, 4, 2020);
INSERT INTO public.quarters_per_year VALUES (9, 1, 2021);
INSERT INTO public.quarters_per_year VALUES (10, 2, 2021);
INSERT INTO public.quarters_per_year VALUES (11, 3, 2021);
INSERT INTO public.quarters_per_year VALUES (12, 4, 2021);
INSERT INTO public.quarters_per_year VALUES (13, 1, 2022);
INSERT INTO public.quarters_per_year VALUES (14, 2, 2022);
INSERT INTO public.quarters_per_year VALUES (15, 3, 2022);
INSERT INTO public.quarters_per_year VALUES (16, 4, 2022);
INSERT INTO public.quarters_per_year VALUES (17, 1, 2023);
INSERT INTO public.quarters_per_year VALUES (18, 2, 2023);
INSERT INTO public.quarters_per_year VALUES (19, 3, 2023);
INSERT INTO public.quarters_per_year VALUES (20, 4, 2023);
INSERT INTO public.quarters_per_year VALUES (21, 1, 2024);
INSERT INTO public.quarters_per_year VALUES (22, 2, 2024);
INSERT INTO public.quarters_per_year VALUES (23, 3, 2024);
INSERT INTO public.quarters_per_year VALUES (24, 4, 2024);
INSERT INTO public.quarters_per_year VALUES (25, 1, 2025);
INSERT INTO public.quarters_per_year VALUES (26, 2, 2025);
INSERT INTO public.quarters_per_year VALUES (27, 3, 2025);
INSERT INTO public.quarters_per_year VALUES (28, 4, 2025);


--
-- Data for Name: shares_numbers_in_million; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shares_numbers_in_million VALUES (2019, 92630.0000, 24230.0000, 1124.0437, 5348.7583, 17757.1980);
INSERT INTO public.shares_numbers_in_million VALUES (2020, 98140.0000, 24500.0000, 1104.6834, 5298.1885, 18097.1281);
INSERT INTO public.shares_numbers_in_million VALUES (2021, 107560.0000, 24790.0000, 1052.2381, 5458.5336, 18279.2283);
INSERT INTO public.shares_numbers_in_million VALUES (2022, 0.0000, 25060.0000, 1012.4399, 5319.1396, 18728.4206);
INSERT INTO public.shares_numbers_in_million VALUES (2023, 0.0000, 24661.0000, 986.7013, 5231.1022, 18442.1965);
INSERT INTO public.shares_numbers_in_million VALUES (2024, 0.0000, 24643.0000, 1042.5131, 5129.5372, 18467.9497);


--
-- Data for Name: valuations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.valuations VALUES (2019, 4.34, 105134, 106340);
INSERT INTO public.valuations VALUES (2020, 9.86, 241546, 232641);
INSERT INTO public.valuations VALUES (2021, 19.48, 482984, 489100);
INSERT INTO public.valuations VALUES (2022, 18.54, 464713, 473669);
INSERT INTO public.valuations VALUES (2023, 36.55, 901409, 908973);
INSERT INTO public.valuations VALUES (2024, 107.80, 2656565, 2658994);


--
-- Data for Name: yearly_financials; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.yearly_financials VALUES (2019, 11716, 3804, 4142, 60.80, -338, 4534, 7182, 3367, -1167);
INSERT INTO public.yearly_financials VALUES (2020, 10918, 2846, 2795, 61.68, 51, 4148, 6770, 3922, -226);
INSERT INTO public.yearly_financials VALUES (2021, 16675, 4532, 4332, 62.40, 200, 6282, 10393, 5864, -418);
INSERT INTO public.yearly_financials VALUES (2022, 26914, 10041, 9753, 64.88, 288, 9438, 17476, 7433, -2005);
INSERT INTO public.yearly_financials VALUES (2023, 26974, 4225, 4368, 56.48, -143, 11620, 15354, 11131, -489);
INSERT INTO public.yearly_financials VALUES (2024, 60922, 32972, 29759, 71.18, 3213, 16601, 44321, 11329, -5272);
INSERT INTO public.yearly_financials VALUES (2025, 130497, 81454, 72880, 75.28, 8574, 32636, 97861, 16405, -16231);


--
-- Data for Name: yearly_financials_extra; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.yearly_financials_extra VALUES (2019, 13292, 3950, 1988, 782, 1206, 4.339, 262);
INSERT INTO public.yearly_financials_extra VALUES (2020, 17315, 5111, 1991, 10896, -8905, 9.859, 381);
INSERT INTO public.yearly_financials_extra VALUES (2021, 28791, 11898, 6963, 847, 6116, 19.483, 1098);
INSERT INTO public.yearly_financials_extra VALUES (2022, 44187, 17575, 10946, 1990, 8956, 18.544, 1174);
INSERT INTO public.yearly_financials_extra VALUES (2023, 41182, 19081, 10953, 3389, 7564, 36.552, 1544);
INSERT INTO public.yearly_financials_extra VALUES (2024, 65728, 22750, 9709, 7280, 2429, 107.802, 1508);
INSERT INTO public.yearly_financials_extra VALUES (2025, 111601, 32274, 8463, 8589, -126, 123.877, 1864);


--
-- Data for Name: yearly_revenue_per_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.yearly_revenue_per_activity VALUES (2019, 1, 5903);
INSERT INTO public.yearly_revenue_per_activity VALUES (2019, 2, 2158);
INSERT INTO public.yearly_revenue_per_activity VALUES (2019, 3, 962);
INSERT INTO public.yearly_revenue_per_activity VALUES (2019, 4, 574);
INSERT INTO public.yearly_revenue_per_activity VALUES (2019, 5, 835);
INSERT INTO public.yearly_revenue_per_activity VALUES (2020, 1, 5518);
INSERT INTO public.yearly_revenue_per_activity VALUES (2020, 2, 2983);
INSERT INTO public.yearly_revenue_per_activity VALUES (2020, 3, 1112);
INSERT INTO public.yearly_revenue_per_activity VALUES (2020, 4, 700);
INSERT INTO public.yearly_revenue_per_activity VALUES (2020, 5, 505);
INSERT INTO public.yearly_revenue_per_activity VALUES (2021, 1, 7759);
INSERT INTO public.yearly_revenue_per_activity VALUES (2021, 2, 6696);
INSERT INTO public.yearly_revenue_per_activity VALUES (2021, 3, 1053);
INSERT INTO public.yearly_revenue_per_activity VALUES (2021, 4, 536);
INSERT INTO public.yearly_revenue_per_activity VALUES (2021, 5, 631);
INSERT INTO public.yearly_revenue_per_activity VALUES (2022, 1, 12462);
INSERT INTO public.yearly_revenue_per_activity VALUES (2022, 2, 10613);
INSERT INTO public.yearly_revenue_per_activity VALUES (2022, 3, 2111);
INSERT INTO public.yearly_revenue_per_activity VALUES (2022, 4, 566);
INSERT INTO public.yearly_revenue_per_activity VALUES (2022, 5, 1162);
INSERT INTO public.yearly_revenue_per_activity VALUES (2023, 1, 13111);
INSERT INTO public.yearly_revenue_per_activity VALUES (2023, 2, 10961);
INSERT INTO public.yearly_revenue_per_activity VALUES (2023, 3, 1544);
INSERT INTO public.yearly_revenue_per_activity VALUES (2023, 4, 903);
INSERT INTO public.yearly_revenue_per_activity VALUES (2023, 5, 455);
INSERT INTO public.yearly_revenue_per_activity VALUES (2024, 1, 12491);
INSERT INTO public.yearly_revenue_per_activity VALUES (2024, 2, 45481);
INSERT INTO public.yearly_revenue_per_activity VALUES (2024, 3, 1553);
INSERT INTO public.yearly_revenue_per_activity VALUES (2024, 4, 1091);
INSERT INTO public.yearly_revenue_per_activity VALUES (2024, 5, 306);
INSERT INTO public.yearly_revenue_per_activity VALUES (2025, 1, 11350);
INSERT INTO public.yearly_revenue_per_activity VALUES (2025, 2, 115186);
INSERT INTO public.yearly_revenue_per_activity VALUES (2025, 3, 1878);
INSERT INTO public.yearly_revenue_per_activity VALUES (2025, 4, 1694);
INSERT INTO public.yearly_revenue_per_activity VALUES (2025, 5, 389);


--
-- Name: activities_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activities_activity_id_seq', 5, true);


--
-- Name: quarters_per_year_yq_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quarters_per_year_yq_id_seq', 28, true);


--
-- Name: activities activities_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_name_key UNIQUE (name);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (activity_id);


--
-- Name: quarterly_financials quarterly_financials_yq_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarterly_financials
    ADD CONSTRAINT quarterly_financials_yq_id_key UNIQUE (yq_id);


--
-- Name: quarters_per_year quarters_per_year_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarters_per_year
    ADD CONSTRAINT quarters_per_year_pkey PRIMARY KEY (yq_id);


--
-- Name: shares_numbers_in_million shares_numbers_in_million_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shares_numbers_in_million
    ADD CONSTRAINT shares_numbers_in_million_year_key UNIQUE (year);


--
-- Name: valuations valuations_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.valuations
    ADD CONSTRAINT valuations_year_key UNIQUE (year);


--
-- Name: yearly_financials_extra yearly_financials_extra_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yearly_financials_extra
    ADD CONSTRAINT yearly_financials_extra_year_key UNIQUE (year);


--
-- Name: yearly_financials yearly_financials_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yearly_financials
    ADD CONSTRAINT yearly_financials_year_key UNIQUE (year);


--
-- Name: quarterly_financials quarterly_financials_yq_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarterly_financials
    ADD CONSTRAINT quarterly_financials_yq_id_fkey FOREIGN KEY (yq_id) REFERENCES public.quarters_per_year(yq_id);


--
-- Name: quarterly_revenue_per_activity quarterly_revenue_per_activity_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarterly_revenue_per_activity
    ADD CONSTRAINT quarterly_revenue_per_activity_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(activity_id);


--
-- Name: quarterly_revenue_per_activity quarterly_revenue_per_activity_yq_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarterly_revenue_per_activity
    ADD CONSTRAINT quarterly_revenue_per_activity_yq_id_fkey FOREIGN KEY (yq_id) REFERENCES public.quarters_per_year(yq_id);


--
-- PostgreSQL database dump complete
--

