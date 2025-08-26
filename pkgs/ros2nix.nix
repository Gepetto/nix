{ python3, writeShellApplication }:
writeShellApplication {
  name = "ros2nix";
  runtimeInputs = [
    (python3.withPackages (p: [
      p.case-converter
      p.catkin-pkg
      p.jinja2
      p.pygithub
    ]))
  ];
  text = ''
    python ${../bin/ros2nix.py} "$@"
  '';
}
