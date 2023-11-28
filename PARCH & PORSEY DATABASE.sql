
ALTER TABLE accounts ADD PRIMARY KEY (id);
ALTER TABLE orders ADD PRIMARY KEY (id);
ALTER TABLE web_events ADD PRIMARY KEY (id);
ALTER TABLE sales_reps ADD PRIMARY KEY (id);
ALTER TABLE region ADD PRIMARY KEY (id);

ALTER TABLE accounts ADD FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(id);
ALTER TABLE web_events ADD FOREIGN KEY (account_id) REFERENCES accounts(id);
ALTER TABLE orders ADD FOREIGN KEY (account_id) REFERENCES accounts(id);
ALTER TABLE sales_reps ADD FOREIGN KEY (region_id) REFERENCES region(id);

ALTER TABLE accounts ADD UNIQUE (name);
ALTER TABLE accounts ALTER COLUMN name SET NOT NULL;
ALTER TABLE web_events ALTER COLUMN occurred_at SET DEFAULT(current_timestamp);
ALTER TABLE web_events ALTER COLUMN occurred_at SET NOT NULL;

SELECT * FROM accounts;

SELECT standard_qty, poster_qty, total, standard_amt_usd, gloss_amt_usd,poster_amt_usd,total_amt_usd 
FROM orders 
WHERE total_amt_usd >0;

 CREATE TABLE region(
	 id int PRIMARY KEY NOT NULL,
  name bpchar 
 );

CREATE TABLE web_events (
	id integer PRIMARY KEY,
	account_id integer,
	occurred_at timestamp,
	channel bpchar
	);
 
 
 CREATE TABLE accounts(
 id int PRIMARY KEY,
 name bpchar UNIQUE,
 website bpcahr,
 lat numeric(10,8),
 long numeric(10,8),
 primary_poc bpchar,
 sales_rep_id int
 );
 
 CREATE TABLE orders(
 id int PRIMARY KEY NOT NULL,
 account_id int,
 occurred_at timestamp,
 standard_qty int,
 gloss_qty int,
 poster_qty int,
 total int,
 standard_amt_usd numeric(10,2),
 gloss_amt_usd numeric (10,2),
 poster_amt_usd numeric (10,2),
 total_amt_usd numeric (10,2)
 );
	 
	 
 CREATE TABLE sales_reps(
 id int PRIMARY KEY NOT NULL,
 name bpchar,
 region_id int
 );


--- QUERY FROM PART TWO
--- QUESTION ONE

SELECT * FROM accounts WHERE name LIKE 'C%';

SELECT * FROM accounts WHERE name LIKE '%one%';

SELECT * FROM accounts WHERE name LIKE '%S';

---QUESTION TWO

SELECT name, primary_poc, sales_rep_id 
FROM accounts
WHERE name IN  ('Walmart','Target','Nordstrom');

--- QUESTION THREE
SELECT * FROM web_events 
WHERE channel IN ('organic','adwords');

--- QUESTION FOUR 

SELECT * FROM orders 
WHERE standard_qty >1000 AND poster_qty = 0 AND  gloss_qty =0;

--- QUESTION FIVE

SELECT * FROM accounts WHERE name NOT LIKE 'C%%S';

--- QUESTION SIX 

SELECT occurred_at, gloss_qty 
FROM orders WHERE gloss_qty BETWEEN 24 AND 29; (Yes it includes the beginning and the end values)

--- QUESTION SEVEN
 SELECT *
  FROM web_events
  WHERE channel IN ('adwords','organic') AND occurred_at >= '2016-01-01'
  ORDER BY occurred_at DESC;
  
--- QUESTION EIGHT 

SELECT id FROM orders WHERE gloss_qty > 4000 OR poster_qty > 4000;

--- QUESTION NINE

SELECT id FROM orders WHERE standard_qty =0 AND gloss_qty > 1000 OR poster_qty > 1000;

--- QUESTION TEN
SELECT * FROM accounts 
WHERE name LIKE 'C%' OR name LIKE 'W%' 
AND primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%' 
AND primary_poc NOT LIKE '%eana%';

SELECT * FROM orders;

SELECT * FROM web_events;

--- QUESTION ELEVEN

SELECT id, (standard_amt_usd/ standard_qty) AS unit_price_standard_paper, account_id
FROM orders
WHERE standard_qty !=0 
ORDER BY unit_price_standard_paper ASC 
LIMIT 10;

--- QUESTION TWELVE

SELECT id, (poster_amt_usd/total_amt_usd)* 100 AS percentage_poster_paper, account_id
FROM orders
WHERE total_amt_usd !=0;

--- QUESTION THIRTEEN
SELECT *
FROM orders 
WHERE gloss_amt_usd >= 1000
ORDER BY gloss_amt_usd ASC
LIMIT 5; 

--- QUESTION FORTEEN
SELECT * 
FROM orders 
WHERE total_amt_usd <500
ORDER BY total_amt_usd ASC
LIMIT 10;


---- SQL JOINS 
---QUESTION ONE

SELECT accounts.primary_poc,accounts.name IN ('Walmart'), web_events.occurred_at, web_events.channel
FROM accounts
JOIN web_events
ON accounts.id = account_id
WHERE name IN ('Walmart');

--- QUESTION TWO 

SELECT sales_reps.name , region.name, accounts.name
FROM sales_reps
JOIN region 
ON sales_reps.region_id = region.id 
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
ORDER BY accounts.name ASC;

---- QUESTION THREE
SELECT region.name, accounts.name,(total_amt_usd/(total+0.001)) AS unitprice
FROM orders
JOIN accounts 
ON orders.account_id=accounts.id
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON sales_reps.region_id= region.id;

---- QUESTION FOUR

SELECT region.name, sales_reps.name, accounts.name
FROM sales_reps
JOIN region 
ON sales_reps.region_id = region.id 
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
WHERE region.name IN ('Midwest')
ORDER BY accounts.name ASC;

---- QUESTION FIVE

SELECT region.name, sales_reps.name , accounts.name
FROM sales_reps
JOIN region 
ON sales_reps.region_id = region.id 
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
WHERE region.name IN ('Midwest') AND sales_reps.name LIKE 'S%'
ORDER BY accounts.name ASC;

---- QUESTION SIX

SELECT region.name, sales_reps.name , accounts.name
FROM sales_reps
JOIN region 
ON sales_reps.region_id = region.id 
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
WHERE region.name IN ('Midwest') AND sales_reps.name LIKE '% K%'
ORDER BY accounts.name ASC;

---- QUESTION SEVEN

SELECT region.name, accounts.name,(total_amt_usd/(total+0.001)) AS unitprice
FROM orders
JOIN accounts 
ON orders.account_id=accounts.id
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON sales_reps.region_id= region.id
WHERE orders.standard_qty > 100;

---- QUESTION EIGHT 

SELECT region.name, accounts.name,(total_amt_usd/(total+0.001)) AS unitprice
FROM orders
JOIN accounts 
ON orders.account_id=accounts.id
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON sales_reps.region_id= region.id
WHERE orders.standard_qty > 100 AND orders.poster_qty >50
ORDER BY unitprice ASC;

---- QUESTION NINE

SELECT DISTINCT accounts.name, web_events.channel
FROM accounts
JOIN web_events
ON accounts.id= web_events.account_id
WHERE accounts.id = '1001';





