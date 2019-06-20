# camt2ofx (compatible with Xero)

Convert camt.053 (XML) files to OFX.

We use this script to **reliably import** our ING bank transactions into Xero.

Xero uses Yodlee for its bank feeds. Unfortunately, Yodlee uses "screen scraping" technology to import the data, which has not proven to be reliable. 

With us this resulted in:
- Incorrect debit / credit values
- Incomplete descriptions
- Duplicate transactions
- No separate "Name" & "Description" field

This script has been tested with the Dutch ING bank, via their camt.053 export. It should also work with other banks.

As long as Xero does not support native bank feeds for ING bank, we will rely on "camt2ofx".

## Setup

##### Requirements

* Ruby 2.x
* RubyGems
* Bundler

##### Clone Git Repository

This application may be cloned or downloaded from GitHub:

```
git clone https://github.com/bluesnotred/camt2ofx.git
```

##### Install Gems

```
bundle install
```

## Usage

Use the script like this  :

```sh
$ ruby camt2ofx.rb my_camt_file.xml
```
The script will create *my_camt_file.xml.ofx* in response.
