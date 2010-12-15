/**
 * jQuery.ajax mid - CROSS DOMAIN AJAX 
 * ---
 * @author James Padolsey (http://james.padolsey.com)
 * @version 0.11
 * @updated 12-JAN-10
 * ---
 * Note: Read the README!
 * ---
 * @info http://james.padolsey.com/javascript/cross-domain-requests-with-jquery/
 */

jQuery.ajax = (function(_ajax){
    
    var protocol = location.protocol,
        hostname = location.hostname,
        exRegex = RegExp(protocol + '//' + hostname),
        YQL = 'http' + (/^https/.test(protocol)?'s':'') + '://query.yahooapis.com/v1/public/yql?callback=?',
        //  [CTH]  Request the page as Base64 encoded data instead of as HTML
        query = 'select * from data.uri where url="{URL}"';
//        query = 'select * from html where url="{URL}" and xpath="*"';
        //  [/CTH]
    
    function isExternal(url) {
        return !exRegex.test(url) && /:\/\//.test(url);
    }
    
    return function(o) {
        
        var url = o.url;
        
        if ( /get/i.test(o.type) && !/json/i.test(o.dataType) && isExternal(url) ) {
            
            // Manipulate options so that JSONP-x request is made to YQL
            
            o.url = YQL;
            o.dataType = 'json';
            
            o.data = {
                q: query.replace(
                    '{URL}',
                    url + (o.data ?
                        (/\?/.test(url) ? '&' : '?') + jQuery.param(o.data)
                    : '')
                ),
                format: 'xml'
            };
            
            // Since it's a JSONP request
            // complete === success
            if (!o.success && o.complete) {
                o.success = o.complete;
                delete o.complete;
            }
            
            o.success = (function(_success){
                return function(data) {
                    
                    if (_success) {
                        //  [CTH]
                        var decoded_base64_data = $.base64Decode($(data.results[0].replace(/\&#xd;/g, '')).text().replace(/(.*base64,)(.*)/, "$2"));
                        _success.call(this, decoded_base64_data);
//                        // Fake XHR callback.
//                        _success.call(this, {
//                            responseText: data.results[0]
//                            // YQL screws with <script>s
//                            // Get rid of them
//                            .replace(/<script[^>]+?\/>|<script(.|\s)*?\/script>/gi, '')
//                        }, 'success');
                        //  [/CTH]
                    }
                    
                };
            })(o.success);
            
        }
        
        return _ajax.apply(this, arguments);
        
    };
    
})(jQuery.ajax);