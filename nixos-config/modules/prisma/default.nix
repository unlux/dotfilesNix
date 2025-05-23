{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # For Prisma:
    # nodePackages_latest.vercel
    nodePackages_latest.prisma
    # openssl
    # nodejs_22
    # Also dont forget to add install postgresql with configuration in some other config file
  ];

  # Prisma:
  environment.variables.PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  environment.variables.PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
  environment.variables.PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
}
