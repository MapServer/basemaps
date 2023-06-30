CONFIG
  ENV
    ##MS_MAP_PATTERN "^/etc/mapserver"

#if _debug > 0 || _layerdebug > 0
    MS_ERRORFILE "stderr"
#endif

    PROJ_LIB _proj_lib
  END
  MAPS
    BASEMAPS "/etc/mapserver/osm-default.map"
  END
END

