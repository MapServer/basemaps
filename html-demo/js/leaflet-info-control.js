/**
 * Created by nicolas Ribot on 15/12/2016.
 * Code from: http://leafletjs.com/examples/extending/extending-3-controls.html
 * Control to display json feature properties (or any other dic)
 * TODO: smart template
 * TODO: bind on json layer and add option to open on feature
 *
 */
L.Control.FeatureInfo = L.Control.extend({
    'options': {
        'htmlTemplate': null,
        'defaultText': 'Fly over feature',
    },

    initialize: function (options) {
        L.Util.setOptions(this, options);
        // Continue initializing the control plugin here.
    },

    onAdd: function (map) {
        this._div = L.DomUtil.create('div', 'leaflet-info-ctrl');
        this.update();
        return this._div;
    },

    onRemove: function (map) {
        // Nothing to do here
    },

    update: function (content) {
        this._div.innerHTML = this._fillContent(content);
    },

    _fillContent: function (content) {
        if (!content) {
            return this.options.defaultText;
        }
        if (this.options.htmlTemplate === null) {
            // builds a default content based on simple html table showing all keys
            return this._buildDefaultContent(content);
        } else {
            // replaces each found key by its value
            var s = this.options.htmlTemplate;
            for (var property in content) {
                var token = '%'+property+'%';
                if (content.hasOwnProperty(property) && this.options.htmlTemplate.indexOf(token) >= 0) {
                    s = s.replace(token, content[property]);
                }
            }
            return s;
        }

    },

    _buildDefaultContent: function(content) {
        var s = '<table class="leaflet-info-ctrl"><thead><tr><td><b>name</b></td><td><b>value</b></td></tr></thead>';
        s += '<tbody>';
        for (var property in content) {
            if (content.hasOwnProperty(property)) {
                s += '<tr><td>' + property + '</td><td>' + content[property] + '</td></tr>';
            }
        }
        s += '</tbody></table>';

        return s;
    }

});

L.control.featureinfo = function (opts) {
    return new L.Control.FeatureInfo(opts);
}

// Example:
// L.control.featureinfo({
//     position: 'bottomleft',
//     htmlTemplate: '',
//     defaultText: 'mousemouse'
// }).addTo(map);
