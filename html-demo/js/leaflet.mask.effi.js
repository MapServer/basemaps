// TODO:move in a plugin/method
// credits: https://github.com/turban/Leaflet.Mask
// changed to work with leaflet 1.0. Nicolas RIbot, 27 aout 2016
L.Mask = L.Polygon.extend({
    options: {
        stroke: false,
        color: '#333',
        fillOpacity: 0.5,
        clickable: true,

        outerBounds: new L.LatLngBounds([-90, -360], [90, 360])
    },

    initialize: function (json, options) {
        // array of exterior + holes
        var latLngs = [];
        var outerBoundsLatLngs = [
            this.options.outerBounds.getSouthWest(),
            this.options.outerBounds.getNorthWest(),
            this.options.outerBounds.getNorthEast(),
            this.options.outerBounds.getSouthEast()
        ];
        // pushes outer ring:
        latLngs.push(outerBoundsLatLngs);

        for (var i = 0; i < json.coordinates.length; i++) {
            var ll = [];
            var coordinates = json.coordinates[i][0];
            // for each part found in the collection, build an array of latlong
            for (var j=0; j<coordinates.length; j++) {
                ll.push(new L.LatLng(coordinates[j][1], coordinates[j][0]));
            }
            latLngs.push(ll);
        }

        L.Polygon.prototype.initialize.call(this, latLngs, options);
    },

});
L.mask = function (latLngs, options) {
    return new L.Mask(latLngs, options);
};
/**
 * Created by nicolas on 27/08/16.
 */
