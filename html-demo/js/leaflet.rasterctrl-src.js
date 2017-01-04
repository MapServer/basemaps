/*
 * L.Control.RasterCtrl shows tools to control raster
 */

L.Control.RasterCtrl = L.Control.extend({
    options: {
        position: 'bottomleft'
    },

    htmlLayout: "<div id='serverdiv'><b>GDAL GRID:</b><form id='form1' method='get'>" +
    "Zone: <select id='selzone' name='selzone'></select> Masque: <select id='selmask' name='selmask'>" +
    "<option value='maskcom'>commune</option><option value='maskstr'>street</option><option value='maskbat'>batiments</option><option value='maskfull'>str+bat</option></select><br/>" +
    "interpolation method: <select id='selmethod' name='method'>" +
    "<option value='invdist'>invdist</option>" +
    "<option value='invdistnn'>invdistnn</option>" +
    "<option value='average'>average</option>" +
    "<option value='nearest'>nearest</option>" +
    "<option value='linear'>linear</option>" +
    "</select><br/>" +
    "Power: <input type='number' name='power'  id='power' min='0' max='100000' step='1' value='2'><br/>" +
    "Smoothing: <input type='number' name='smoothing' id='smoothing' min='0' max='10000' step='2' value='0'><br/>" +
    "Radius1: <input type='number' name='radius1' id='radius1' min='-1' max='10000' step='1' value='0'><br/>" +
    "Radius2: <input type='number' name='radius2' id='radius2' min='-1' max='10000' step='1' value='0'><br/>" +
    "Angle: <input type='number' name='angle' id='angle' min='-1' max='10000' step='1' value='0'><br/>" +
    "<input type='text' id='rval1' name='rval1' value='213'/> <input type='color' id='clr1' name='clr1' value='#2E9A58'><br/>" +
    "<input type='text' id='rval2' name='rval2' value='250'/> <input type='color' id='clr2' name='clr2' value='#FBFF80'><br/>" +
    "<input type='text' id='rval3' name='rval3' value='300'/> <input type='color' id='clr3' name='clr3' value='#E06C1F'><br/>" +
    "<input type='text' id='rval4' name='rval4' value='350'/> <input type='color' id='clr4' name='clr4' value='#C83737'><br/>" +
    "<input type='text' id='rval5' name='rval5' value='403'/> <input type='color' id='clr5' name='clr5' value='#FF0000'><br/>" +
    "<input type='checkbox' id='slope' name='slope'/> Ombrages relief + alti ramp<br/>" +
    "93048: 0%<input type='range' value='75' id='clrrangeSlider1' min='0' max='100' step='2'>100%<br/>" +
    "06088: 0%<input type='range' value='75' id='clrrangeSlider2' min='0' max='100' step='2'>100%<br/>" +
    "35051: 0%<input type='range' value='75' id='clrrangeSlider3' min='0' max='100' step='2'>100%<br/>" +
    // "Presets:<br/>" +
    // "<input type='radio' id='presets1' name='presets'><label for='presets1'>Invidist default</label><br/>" +
    // "<input type='radio' id='presets2' name='presets'><label for='presets2'>Linear default</label><br/>" +
    // "<input type='radio' id='presets3' name='presets'><label for='presets3'>Invidistnn defautl</label><br/>" +
    // "<input type='radio' id='presets4' name='presets'><label for='presets4'>custom ramp</label><br/>" +
    "<input type='submit' value='O K' id='submitbtn'/><span id='waitmsg'> Raster processing<span id='dots'></span></span></form></div>",

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