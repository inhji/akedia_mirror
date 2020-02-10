Brid.gy
======================

fed.brid.gy
----------------------

* Post Form needs to expose the field `:bridgy_fed`
* If `:bridgy_fed` is set to true, `post_meta.html` automatically renders link to `fed.brid.gy`
* Create/Update actions need to add a Webmention job to the queue
* Webmention Worker needs to support post type
* Link gets picked up and the mention is sent to `fed.brid.gy`