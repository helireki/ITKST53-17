import lxml.html
import lxml.html.clean
import slimit.ast
import slimit.parser
import lab6visitor

from debug import *

libcode = '''
<script>
    var sandbox_document = {
        getElementById: function(id) {
            var e = document.getElementById('sandbox-' + id);
            return {
                get onclick() { return e.onclick; },
                set onclick(h) { e.onclick = h; },
                get textContent() { return e.textContent; },
                set  textContent(h) {e.textContent = h; },
            }
        },
    };

    // Do not change these functions.
    function sandbox_grader(url) {
        window.location = url;
    }
    function sandbox_grader2() {
        eval("1 + 1".toString());  // What could possibly go wrong...
    }
    function sandbox_grader3() {
        try {
            eval(its_okay_no_one_will_ever_define_this_variable);
        } catch (e) {
        }
    }
 
    function sandbox_setTimeout(f, secs) {
        if (typeof f == "function"){
            setTimeout(f, secs);
      }
    }

    function check(s) {
        var ret = s === "__proto__" || s === "constructor" || s === "__defineGetter__" || s === "__defineSetter__";
        return ret;
    }

    function bracket_check(s) {
        if (check(s)){
            return "__invalid__";
        }
        else {
            s.toString = Object.prototype.toString();
            s.valueOf = Object.prototype.valueOf();
            return s;
        }
    }
 
    function this_check(s) {
        if (s === window) return null;
        return s;
    }
</script>
'''

def filter_html_cb(s, jsrewrite):
    cleaner = lxml.html.clean.Cleaner()
    cleaner.scripts = False
    cleaner.style = True
    doc = lxml.html.fromstring(s)
    clean = cleaner.clean_html(doc)
    for el in clean.iter():
        if el.tag == 'script':
            el.text = jsrewrite(el.text)
            for a in el.attrib:
                del el.attrib[a]
        if 'id' in el.attrib:
            el.attrib['id'] = 'sandbox-' + el.attrib['id']
    return lxml.html.tostring(clean)

@catch_err
def filter_js(s):
    parser = slimit.parser.Parser()
    tree = parser.parse(s)
    visitor = lab6visitor.LabVisitor()
    return visitor.visit(tree)

@catch_err
def filter_html(s):
    return libcode + filter_html_cb(s, filter_js)

