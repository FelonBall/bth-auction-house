# BTH Auction House - DV1663 Final Project

A web-based online auction platform built for the DV1663 Databasteknik final project at BTH.

**Author:** Theodor Buskenström

## Stack

- **Database:** MySQL 8
- **Backend:** Python 3 + Flask
- **DB driver:** `mysql-connector-python`
- **Templating:** Jinja2 (server-rendered HTML)
- **Data generation:** Faker

## Project structure

```
.
├── app/                      # Flask application
│   ├── __init__.py           # app factory
│   ├── db.py                 # MySQL connection helper
│   ├── auth.py               # register / login / logout
│   ├── auctions.py           # browse / view / create auctions
│   ├── bids.py               # place bid endpoint
│   ├── watchlist.py          # watchlist add/remove/view
│   └── templates/            # Jinja2 templates
├── sql/
│   ├── 01_schema.sql         # CREATE TABLE statements
│   ├── 02_routines.sql       # triggers, procedures, functions
│   └── 03_seed_categories.sql # initial categories
├── seed.py                   # generates fake users/items/auctions/bids
├── requirements.txt
├── .env.example              # copy to .env and fill in
├── run.py                    # entrypoint: `python run.py`
├── dump.sql                  # mysqldump output (for submission)
└── docs/
    ├── ER-diagram.png
    └── Report.pdf
```

## Setup

1. **Install MySQL 8** and create the database:

   ```sql
   CREATE DATABASE auction_house CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

2. **Load the schema and routines:**

   ```bash
   mysql -u root -p auction_house < sql/01_schema.sql
   mysql -u root -p auction_house < sql/02_routines.sql
   mysql -u root -p auction_house < sql/03_seed_categories.sql
   ```

3. **Set up Python environment:**

   ```bash
   python -m venv venv
   venv\Scripts\activate
   pip install -r requirements.txt
   ```

4. **Configure environment:**

   ```bash
   copy .env.example .env
   ```

   Edit `.env` and set your MySQL credentials.

5. **Generate seed data:**

   ```bash
   python seed.py
   ```

6. **Run the app:**

   ```bash
   python run.py
   ```

   Visit http://localhost:5000

## Restoring from dump

```bash
mysql -u root -p auction_house < dump.sql
```
