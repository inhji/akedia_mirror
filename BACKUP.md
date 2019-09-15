Backup & Restore
=================

Backup
-------

Backup is done via [borg](https://www.borgbackup.org/), which saves: 

* A Database dump
* The `prod.secret.exs` file
* The uploads folder

Restore
--------

0. Drop the existing database:

```elixir
mix ecto.drop
```

1. Create new database

```bash
sudo -u postgres psql 
```

```sql
CREATE NEW DATABASE akedia_prod;
```

2. Import data

```bash
sudo -u postgres psql -d akedia_dev -f akedia.sql
```

3. Copy uploads folder

4. Copy `prod.secret.exs`