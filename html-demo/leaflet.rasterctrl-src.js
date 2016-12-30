/*
 * L.Control.RasterCtrl shows tools to control raster
 */

L.Control.RasterCtrl = L.Control.extend({
    options: {
        position: 'bottomleft'
    },

    htmlLayout: "<div id='clientdiv'>Client: raster transparency</div>" +
    "<div id='serverdiv'>server: interpolation method:</div>",

    onAdd: function (map) {
        this._map = map;
        this._container = L.DomUtil.create('div', 'leaflet-control-rasterctrl-display leaflet-bar-part leaflet-bar');
        this._container.innerHTML = this.htmlLayout;
        return this._container;
    },

    onRemove: function (map) {
        // map.off('zoomend', this.onMapZoomEnd, this);
    },

    onMapZoomEnd: function (e) {
        // this.updateMapZoom(this._map.getZoom());
    },

    updateMapZoom: function (zoom) {
        // this._container.innerHTML = zoom;
    }
});

L.Map.mergeOptions({
    rasterCtrl: true
});

L.Map.addInitHook(function () {
    if (this.options.rasterCtrl) {
        this.rasterCtrl = new L.Control.RasterCtrl();
        this.addControl(this.rasterCtrl);
    }
});

L.control.rasterCtrl = function (options) {
    return new L.Control.RasterCtrl(options);
};