/*
 * L.Control.ReliefCtrl shows tools to control relief
 */

L.Control.ReliefCtrl = L.Control.extend({
    options: {
        position: 'bottomleft'
    },

    htmlLayout: "<div id='serverdiv'><b>GDAL DEM Processing:</b>" +
    "<form id='form1' method='get'>DEM: TODO<br/>" +
    "<label for='reliefcb'>relief (color)</label><input type='checkbox' id='reliefcb' name='reliefcb' checked/> " +
    "<label for='slopecb'>slope</label><input type='checkbox' id='slopecb' name='slopecb' checked/> " +
    "<label for='hillshadecb'>hillshade</label><input type='checkbox' id='hillshadecb' name='hillshadecb' checked/><br/>" +
    "<label for='hillshadecb'>hillshade</label><input type='checkbox' id='hillshadecb' name='hillshadecb' checked/><br/>" +
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
        this._container = L.DomUtil.create('div', 'leaflet-control-reliefctrl-display leaflet-bar-part leaflet-bar');
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
    reliefCtrl: true
});

L.Map.addInitHook(function () {
    if (this.options.reliefCtrl) {
        this.reliefCtrl = new L.Control.ReliefCtrl();
        this.addControl(this.reliefCtrl);
    }
});

L.control.reliefCtrl = function (options) {
    return new L.Control.ReliefCtrl(options);
};