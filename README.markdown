# www.u2764.com

This is the repository for <https://www.u2764.com/>—which you should just browse directly if itʼs your first time viewing.

However, if you want to download the whole site all at once, this is the place.

## Documents &amp; Naming

Documents are stored in `/XXXX/YYYY-MM-DD/zzz/` directories according to the following policies :—

+ `XXXX` is a four-character category identifier, composed of uppercase A·S·C·I·I letters.

+ `YYYY-MM-DD` is the stated original publication date of the resource.  In rare cases, this may differ from the actual initial publication datetime recorded in the corresponding Atom file.

+ `zzz` is an `NCName`.

The identifier for the document is an `NCName` formed from these components: `XXXX.YYYY-MM-DD.zzz`.  This leaves open the possibility of two documents sharing the same final component `zzz`, although this will generally be avoided.

## Cataloguing

Documents in each category `XXXX` are catalogued in the Atom file `/XXXX/index.atom` and viewable on the web from the generated (in‐browser) index `/XXXX/index.xhtml`.  All entries in this file must be from the same year.  Previous years are archived according to the practices set forth in [RFC 5005](https://www.rfc-editor.org/rfc/rfc5005.html), with entries from year `YYYY` stored in `/XXXX/archive-YYYY.atom`.

## Licensing

Except where otherwise mentioned, the documents in this repository are copyright © [Margaret KIBI](https://go.KIBI.family/About/#me) and licensed under a <a href="https://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons Attribution-ShareAlike 4.0 International License [🅭🅯🄎]</a>.  There are some exceptions; if a directory or file carries a different copyright statement, this one does not apply.
