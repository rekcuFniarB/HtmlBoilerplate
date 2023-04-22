This simple util makes html files complete by adding <html>, <head> and <body> tags if content isn't wrapped into <body> tag.
If supplied file has .md extension then additional [markdown-it](https://github.com/markdown-it/markdown-it#readme) script is added into resulting html file for converting markdown to html.
Supplied html file will be overwritten by this script.

3rd party projects this utils relies on:

* https://github.com/markdown-it/markdown-it#readme
* https://github.com/kognise/water.css#readme


Usage
-----

    makehtml.sh  file.html
    makehtml.sh  file.md

Examples
--------

You write `example.html`:

```html
<code class="markdown"><pre>
Document 1
==========

Some list

* item 1
* item 2
* item 3
</pre></code>
```

After applying `makehtml.sh example.html` resulting code will be:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>example</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css/out/water.css">
    <!-- Other css alternatives: https://css-tricks.com/no-class-css-frameworks/ -->
  </head>
  <body>
    <main>
    <code class="markdown"><pre>
Document 1
==========

Some list

* item 1
* item 2
* item 3
</pre></code>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/markdown-it/dist/markdown-it.min.js" type="text/javascript"></script>
<script type="text/javascript">
    // some helper script to init markdown processing
</script>
  </body>
</html>
```

Same result will be if this script is applied on `.md` file.


Why
---

In the past I kept local notes for myself in `.md` files but they needed special viewer or converting to html. Instead I can just embed markdown inside portable html files which can be viewed anywhere with no extra software required. Next time I just edit these html's directly with no source `.md` required.
