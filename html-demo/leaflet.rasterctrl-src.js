/*
 * L.Control.RasterCtrl shows tools to control raster
 */

L.Control.RasterCtrl = L.Control.extend({
    options: {
        position: 'bottomleft'
    },

    htmlLayout: "<div id='serverdiv'><b>GDAL GRID:</b><form id='form1' method='get'>interpolation method: <select id='selmethod' name='method'>" +
    "<option default>invdist</option>" +
    "<option default>invdistnn</option>" +
    "<option default>average</option>" +
    "<option default>nearest</option>" +
    "<option default>linear</option>" +
    "</select><br/>" +
    "Power: <input type='number' name='power' min='0' max='100000' step='1' value='2'><br/>" +
    "Smoothing: <input type='number' name='smoothing' min='0' max='10000' step='2' value='0'><br/>" +
    "Radius1: <input type='number' name='radius1' min='-1' max='10000' step='1' value='0'><br/>" +
    "Radius2: <input type='number' name='radius2' min='-1' max='10000' step='1' value='0'><br/>" +
    "Angle: <input type='number' name='angle' min='-1' max='10000' step='1' value='0'><br/>" +
    "<input type='text' id='rval1' name='rval1' value='213'/> <input type='color' id='clr1' name='clr1' value='#2E9A58'><br/>" +
    "<input type='text' id='rval2' name='rval2' value='250'/> <input type='color' id='clr2' name='clr2' value='#FBFF80'><br/>" +
    "<input type='text' id='rval3' name='rval3' value='300'/> <input type='color' id='clr3' name='clr3' value='#E06C1F'><br/>" +
    "<input type='text' id='rval4' name='rval4' value='350'/> <input type='color' id='clr4' name='clr4' value='#C83737'><br/>" +
    "<input type='text' id='rval5' name='rval5' value='403'/> <input type='color' id='clr5' name='clr5' value='#FF0000'><br/>" +
    // "Presets:<br/>" +
    // "<input type='radio' id='presets1' name='presets'><label for='presets1'>Invidist default</label><br/>" +
    // "<input type='radio' id='presets2' name='presets'><label for='presets2'>Linear default</label><br/>" +
    // "<input type='radio' id='presets3' name='presets'><label for='presets3'>Invidistnn defautl</label><br/>" +
    // "<input type='radio' id='presets4' name='presets'><label for='presets4'>custom ramp</label><br/>" +
    "<input type='submit' value='O K'/></form></div>",

    onAdd: function (map) {
        this._map = map;
        this._container = L.DomUtil.create('div', 'leaflet-control-rasterctrl-display leaflet-bar-part leaflet-bar');
        this._container.innerHTML = this.htmlLayout;

        // removes some events
        // Disable dragging when user's cursor enters the element
        this._container.addEventListener('mouseover', function () {
            map.dragging.disable();
            map.doubleClickZoom.disable();
        });

        // Re-enable dragging when user's cursor leaves the element
        this._container.addEventListener('mouseout', function () {
            map.dragging.enable();
            map.doubleClickZoom.enable();
        });

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