CONFIG
  ENV
    MS_MAP_PATTERN "^\/etc\/mapserver\/([^\.][-_A-Za-z0-9\.]+\/{1})*([-_A-Za-z0-9\.]+\.map)"

#if _debug > 0 || _layerdebug > 0
    MS_ERRORFILE "stderr"
#endif

  END
  MAPS
    BASEMAPS "/etc/mapserver/osm-google.map"
  END
END

