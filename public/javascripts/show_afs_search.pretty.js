(function () {
  var a = null,
      g = window,
      i = g.googleSearchResizeIframe || g.googleSearchPath && g.googleSearchPath == "/cse" && typeof g.googleSearchResizeIframe == "undefined",
      j = document.location.protocol,
      k = document.location.search,
      m, o, p;

  function q(c, b, d, e) {
    for (var f = {}, c = c.split(d), d = 0; d < c.length; d++) {
      var h = c[d],
          n = h.indexOf(b);
      if (n > 0) {
        var l = h.substring(0, n),
            l = e ? l.toUpperCase() : l.toLowerCase(),
            h = h.substring(n + 1, h.length);
        f[l] = h
      }
    }
    return f
  }
  function r(c, b) {
    return b ? "&" + c + "=" + encodeURIComponent(b) : ""
  }

  function s() {
    var c = "";
    c += g.googleSearchDomain ? g.googleSearchDomain : "www.google.com";
    var b = !1;
    c += g.googleSearchPath ? g.googleSearchPath : "/custom";
    c = (b ? j : "http:") + "//" + c + "?";
    if (g.googleSearchQueryString) g.googleSearchQueryString = g.googleSearchQueryString.toLowerCase();
    var d;
    b = k;
    if (b.length < 1) d = "";
    else {
      b = b.substring(1, b.length);
      b = q(b, "=", "&", !1);
      if (g.googleSearchQueryString != "q" && b[g.googleSearchQueryString]) b.q = b[g.googleSearchQueryString], delete b[g.googleSearchQueryString];
      if (b.cof) {
        var e = q(decodeURIComponent(b.cof), ":", ";", !0);
        (e = e.FORID) && (m = parseInt(e, 10))
      }
      if (e = document.getElementById(g.googleSearchFormName)) {
        if (e.q && b.q && (!b.ie || b.ie.toLowerCase() == "utf-8")) e.q.value = decodeURIComponent(b.q.replace(/\+/g, " "));
        if (e.sitesearch) for (var f = 0; f < e.sitesearch.length; f++) e.sitesearch[f].checked = b.sitesearch == a && e.sitesearch[f].value == "" ? !0 : e.sitesearch[f].value == b.sitesearch ? !0 : !1
      }
      e = "";
      for (d in b) e += "&" + d + "=" + b[d];
      d = e.substring(1, e.length)
    }
    c += d;
    c += r("ad", "w" + o);
    c += r("num", p);
    c += r("adtest", g.googleAdtest);
    if (i) d = g.location.href, b = d.indexOf("#"), b != -1 && (d = d.substring(0, b)), c += r("rurl", d);
    return c
  }

  function t() {
    (o = g.googleSearchNumAds) || (o = 9);
    p = (p = g.googleNumSearchResults) ? Math.min(p, 20) : 10;
    var c = {
      9: 795,
      10: 795,
      11: 500
    },
        b = {};
    /* [CTH]
    b[9] = 300 + 90 * p;
    b[10] = 300 + 50 * Math.min(o, 4) + 90 * p;
    b[11] = 300 + 50 * o + 90 * p;
    */  
    b[9] = 90 * p;
    b[10] = 50 * Math.min(o, 4) + 90 * p;
    b[11] = 50 * o + 90 * p;
    // [/CTH]
    var d = s();
    if (!g.googleSearchFrameborder) g.googleSearchFrameborder = "0";
    var e = document.getElementById(g.googleSearchIframeName);
    if (e && c[m]) {
      var c = g.googleSearchFrameWidth ? Math.max(g.googleSearchFrameWidth, c[m]) : c[m],
          b = g.googleSearchFrameHeight ? Math.max(g.googleSearchFrameHeight, b[m]) : b[m],
          f = document.createElement("iframe"),
          d = {
          name: "googleSearchFrame",
          src: d,
          frameBorder: g.googleSearchFrameborder,
          width: c,
          height: b,
          marginWidth: "0",
          marginHeight: "0",
          hspace: "0",
          vspace: "0",
          allowTransparency: "true",
          scrolling: "no"
          },
          h;
      for (h in d) f.setAttribute(h, d[h]);
      e.appendChild(f);
      f.attachEvent ? f.attachEvent("onload", function () {
        window.scrollTo(0, 0)
      }) : f.addEventListener("load", function () {
        window.scrollTo(0, 0)
      }, !1);
      i && g.setInterval(function () {
        if (g.location.hash && g.location.hash != "#") {
          var b = g.location.hash.substring(1) + "px";
          if (f.height != b && b != "0px") f.height = b
        }
      }, 10)
    }
    g.googleSearchIframeName = a;
    g.googleSearchFormName = a;
    g.googleSearchResizeIframe = a;
    g.googleSearchQueryString = a;
    g.googleSearchDomain = a;
    g.googleSearchPath = a;
    g.googleSearchFrameborder = a;
    g.googleSearchFrameWidth = a;
    g.googleSearchFrameHeight = a;
    g.googleSearchNumAds = a;
    g.googleNumSearchResults = a;
    g.googleAdtest = a
  }
  t();
})();
