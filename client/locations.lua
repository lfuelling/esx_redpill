Locations = {
    RedpillMarker = {
        Entry = { x = -2050.62, y = 3236.5, z = 31.5 }, -- Fort Zancudo bunker elevator
        Exit = { x = -2056.73, y = 3239.95, z = 31.5 }
    },
    CommRoom = { x = 154.31, y = -764.62, z = 258.2, hdg = 164.48, -- IAA Building top floor comm room
                 Pc = { x = 153.25, y = -767.46, z = 258.15, -- Desk with switched on monitors in comm room
                        machine = {
                            user = "root",
                            commands = { "echo", "help" }
                        }
                 },
                 Exit = { x = 150.9, y = -762.94, z = 258.15 } -- Comm room door
    },
    LiveInvader = {
        AdminPc = { x = -1053.16, y = -230.2, z = 44.02, -- LiveInvader server room pc
                    machine = {
                        user = "root",
                        commands = { "echo", "help" }
                    }
        },
        DevPc = { x = -1050.67, y = -240.57, z = 44.02, -- Dev pc next to main meeting room
                  machine = {
                      user = "root",
                      commands = { "echo", "help" }
                  }
        },
    },
    Carrier = {
        BridgePc = { x = 3084.72, y = -4686.57, z = 27.25, -- laptop at bridge of carrier
                     machine = {
                         user = "root",
                         commands = { "echo", "help" }
                     }
        }
    },
    Merryweather = { -- Merryweather Dock
        DualMonitorPc1 = { x = 570.88, y = -3123.73, z = 18.77,
                           machine = {
                               user = "root",
                               commands = { "echo", "help" }
                           }
        },
        DualMonitorPc2 = { x = 563.08, y = -3124.32, z = 18.77,
                           machine = {
                               user = "root",
                               commands = { "echo", "help" }
                           }
        }
    },
    Lester = { -- Lesters Home
        MainPc = { x = 1275.73, y = -1710.53, z = 54.77,
                   machine = {
                       user = "root",
                       commands = { "echo", "help" }
                   }
        },
        SecondaryPc = { x = 1272.31, y = -1711.54, z = 54.77,
                        machine = {
                            user = "root",
                            commands = { "echo", "help" }
                        }
        },
        FactoryPc = { x = 707.39, y = -966.97, z = 30.41,
                      machine = {
                          user = "root",
                          commands = { "echo", "help" }
                      }
        }
    },
    Franklin = { -- Franklins (new) Home
        KitchenPc = { x = -7.82, y = 520.31, z = 174.63,
                      machine = {
                          user = "root",
                          commands = { "echo", "help" }
                      }
        }
    },
    Stores = { -- Some stores
        GasStation1Pc = { x = 1159.77, y = -315.2, z = 69.21,
                          machine = {
                              user = "root",
                              commands = { "echo", "help" }
                          }
        },
        TequiLaLaDjPc = { x = -560.83, y = 280.8, z = 85.68,
                          machine = {
                              user = "root",
                              commands = { "echo", "help" }
                          }
        }
    },
    Bank = { -- The bank next to the cinema (not UD)
        OfficePc = { x = 247.42, y = 208.71, z = 110.28,
                     machine = {
                         user = "root",
                         commands = { "echo", "help" }
                     }
        },
        BackOfficePc1 = { x = 261.2, y = 204.95, z = 110.29,
                          machine = {
                              user = "root",
                              commands = { "echo", "help" }
                          }
        },
        BackOfficePc2 = { x = 264.42, y = 211.12, z = 110.29,
                          machine = {
                              user = "root",
                              commands = { "echo", "help" }
                          }
        },
        VaultPc = { x = 264.82, y = 219.85, z = 101.68,
                    machine = {
                        user = "root",
                        commands = { "echo", "help" }
                    }
        },
    } }