# =============================================================
# Functions for generating web pages to view tests
# =============================================================

# This is the function that the user calls
# * outdir: the output directory
# * convertpng: if TRUE, convert the source PDFs files to PNG instead.
# TODO: Create overall index file
# TODO: Add filter?
#' @export
vtest_webpage <- function(ref = "", pkg = NULL, resultdir = NULL, convertpng = TRUE) {
  pkg <- as.package(pkg)

  if (is.null(resultdir))
    resultdir <- find_default_resultdir()

  htmldir <- file.path(resultdir, "html")

  if (!file.exists(htmldir))
    dir.create(htmldir, recursive = TRUE)
  else
    unlink(dir(htmldir, full.names = TRUE))

  if (ref == "") {
    reftext <- "last local test"
    testinfo <- read.csv(file.path(resultdir, "lasttest.csv"), stringsAsFactors = FALSE)
  } else {
    reftext <- ref
    refh <- git_find_commit_hash(pkg$path, ref)
    testinfo <- get_testinfo(commit = refh, resultdir = resultdir)
  }

  make_vtest_indexpage(testinfo, resultdir, reftext)

  ddply(testinfo, .(context), .fun = function(ti) {
      make_vtest_contextpage(ti, resultdir, reftext, convertpng)
  })

  invisible()
}

make_vtest_indexpage <- function(testinfo, resultdir = NULL, reftext = "") {
  print(unique(testinfo$context))
}


make_vtest_contextpage <- function(testinfo, resultdir = NULL, reftext = "", convertpng = TRUE)  {
  if (is.null(resultdir))  stop("resultdir cannot be NULL")

  # Sort by order
  testinfo <- testinfo[order(testinfo$order), ]

  # Get context
  context <- unique(testinfo$context)
  if (length(context) != 1)
    stop("There is not exactly one context in this subset: ", context)

  htmlfile <- file.path(normalizePath(file.path(resultdir, "html")),
                        paste(context, "html", sep="."))
  message("Writing ", htmlfile)

  write(paste('<html><head>\n',
        '<link rel="stylesheet" type="text/css" href="../style.css" media="screen" />',
        '<title>Visual tests: ', context,
        '</title></head><body><h1>Visual tests: ', context,
        '</h1>\n',
        '<h2>Results for <span class="refspec">', reftext,'</span></h2>\n',
        sep = ""), htmlfile)

  # Write HTML code to show a single test
  item_html <- function(t, convertpng = FALSE) {
    if (convertpng) f <- paste(t$hash, "png", sep=".")
    else            f <- paste(t$hash, t$type , sep=".")

    paste('<div class="float">\n',
          '  <div class="header">',
          '    <p class="description">', t$desc, '</p>\n',
          '  </div>\n',
          '  <div class="imageset">\n',
          '    <span class="imagewrap">\n',
          '      <div class="image"><img src="', f, '"></div>\n',
          '      <div class="hash">', t$hash, '</div>\n',
          '    </span>\n',
          '  </div>\n',
          '</div>\n', sep="")
  }

  # Get the list of info about all tests, then write information about each of the items
  for (i in seq_len(nrow(testinfo))) {
    write(item_html(testinfo[i, ], convertpng), htmlfile, append = TRUE)
  }

  write('</body></html>', htmlfile, append = TRUE)

  if (convertpng) {
    convert_png(testinfo$hash, file.path(resultdir, "images"),
      file.path(resultdir, "html"))
  } else {
    file.copy(file.path(resultdir, "images", testinfo$hash),
      file.path(resultdir, "html", paste(testinfo$hash, ".pdf", sep="")))
  }

  return(htmlfile)
}
