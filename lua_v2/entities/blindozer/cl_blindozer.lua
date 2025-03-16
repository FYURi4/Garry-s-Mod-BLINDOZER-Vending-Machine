include('sh_blindozer.lua')
resource.AddFile("resource/fonts/Cyrvetica-v2-Extra-Outline.ttf")
resource.AddFile("resource/fonts/Ithaka-Regular.ttf")

if CLIENT then
    surface.CreateFont( "System_Loadings", {
        font = "Arial",
        size = 20,
        weight = 2000,
        antialias = true,
    } )

    surface.CreateFont( "gui_sleep_screen", {
        font = "Arial",
        size = 70,
        weight = 2000,
        antialias = true,
    } )

    surface.CreateFont( "gui_sleep_screenV2", {
        font = "Cyrvetica v2 Extra Outline",
        size = 70,
        weight = 2000,
        antialias = true,
        extended = true,
    } )

    surface.CreateFont( "gui_sleep_screen1", {
        font = "Arial",
        size = 60,
        weight = 10,
        antialias = true,
    } )

    surface.CreateFont( "gui_sleep_screen2", {
        font = "Arial",
        size = 40,
        weight = 10,
        antialias = true,
    } )

    surface.CreateFont( "gui_sleep_screen3", {
        font = "ithaka Regular",
        size = 80,
        weight = 10,
        antialias = true,
        extended = true,
    } )

    surface.CreateFont( "TheDefaultSettings", {
        font = "Arial",
        size = 19,
        weight = 2000,
        antialias = true,
    } )

    surface.CreateFont( "TheDefaultSettings1", {
        font = "Arial",
        size = 25,
        weight = 2000,
        antialias = true,
    } )

    surface.CreateFont( "blindozer_info_tab_localization", {
        font = "Arial",
        size = 25,
        weight = 100,
        antialias = true,
    } )

    surface.CreateFont( "blindozer_info_tab_localization2", {
        font = "Arial",
        size = 25,
        weight = 2000,
        antialias = true,
    } )

    surface.CreateFont("TitleS", {
        font = "Arial",
        size = 68,
        weight = 500,
        antialias = true,
    } )

    surface.CreateFont("Title", {
        font = "Arial",
        size = 30,
        weight = 2000,
        antialias = true,
    } )

    surface.CreateFont("Title2", {
        font = "Arial",
        size = 25,
        weight = 500,
        antialias = true,
    } )

    surface.CreateFont("TitlePay", {
        font = "Arial",
        size = 25,
        weight = 2000,
        antialias = true,
    } )
    
end

hook.Add("CalcView", "MovePlayerCamera", function(ply, pos, angles, fov) 
    local Position = ply:GetNWVector("Position") or Vector(0, 0, 0) 
    local Angles = ply:GetNWAngle("Angles") or Angle(0, 0, 0)

    local view = {}

    local currentPos = ply:GetNWVector("CurrentPosition") or pos
    local currentAngles = ply:GetNWAngle("CurrentAngles") or angles

    local lerpSpeed = 0.1

    local ent = ply:GetEyeTrace().Entity

    if ply:GetNWBool("isUsingEntity") then
        gui.EnableScreenClicker(true)
        currentPos = LerpVector(lerpSpeed, currentPos, Position)
        currentAngles = LerpAngle(lerpSpeed, currentAngles, Angles)

        ply:SetNWVector("CurrentPosition", currentPos)
        ply:SetNWAngle("CurrentAngles", currentAngles)

        view.origin = currentPos
        view.angles = currentAngles

        if not ply:GetNWBool("CameraReachedTarget") then
            local posDiff = currentPos - Position
            local angDiff = currentAngles - Angles
            if posDiff:Length() < 0.1 and math.abs(angDiff.y) < 0.1 and math.abs(angDiff.p) < 0.1 and math.abs(angDiff.r) < 0.1 then
                ply:SetNWBool("CameraReachedTarget", true)
            end
        end
    else
        gui.EnableScreenClicker(false)
        view.origin = pos
        view.angles = angles
        ply:SetNWVector("CurrentPosition", pos)
        ply:SetNWAngle("CurrentAngles", angles)
        ply:SetNWBool("CameraReachedTarget", false)
    end

    view.fov = fov
    return view
end)

local alpha = 255
local linesDrawn = 0


////                                                                                                                                                                                  \\\\
//////////////////////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////                                                                                                                                                                                  \\\\


function ENT:Initialize()
    self.WindowSizeX, self.WindowSizeY = 1100, 856
    self.bler_addother = bler_addother
    self.dobavka_list_CoSaB = dobavka_list_CoSaB
    self.dobavka_list_CoSwB = dobavka_list_CoSwB
    self.dobavka_list_SaB = dobavka_list_SaB
    self.dobavka_list_SwB = dobavka_list_SwB
    self.current_page = 1
    self.scrollOffset = 0
    self.scrollSpeed = 5 
    self.settings = {};
    self:LoadConfig();
    self.language = self.settings.setting2 or "Russian";
    self.lines = {};
    self.currentLine = 1;
    self.delayBetweenLines = 1;
    self.lineHeight = 30;
    self.maxLines = 10 ;
    self.system_start = true;
    self.gui_sleep_screen = true;
    self.currentScreen = 1;
    self.clicked_position = nil;
    self.screenChangeTime = CurTime() + 10;
    self.position_allowed = {};
    self.lastMouseMove = 0;
end


////                                                                                                                                                                                  \\\\
//////////////////////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////                                                                                                                                                                                  \\\\



//_Блин_Сырный_145гр_//_Блин_Ветчина_и_сыр_145гр_//___Блин_Пикник_150гр___//___Блин_Голандский_150гр___//___Блин_Овощной_142гр___//___Блин_Вишневый_145гр___//___Блин_Абрикосовый_145гр___//
//___________________//__________________________//_______________________//___________________________//________________________//_________________________//____________________________//
//___Тесто___100гр___//____Тесто_______100гр_____//___Тесто______100гр____//______Тесто______100гр_____//____Тесто_____100гр_____//__Тесто___________100гр__//__Тесто______________100гр__//
//___Сыр______45гр___//____Сыр________22.5гр_____//___Сыр_______12.5гр____//______Сыр_______16.6гр_____//____Огурцы_____21гр_____//__Вишневый_джем____45гр__//__Абрикосовый_джем____45гр__//
//___________________//____Ветчина____22.5гр_____//___Ветчина___12.5гр____//______Ветчина___16.6гр_____//____Помидоры___21гр_____//_________________________//____________________________//
//___________________//__________________________//___Огурцы____12.5гр____//______Лук_фри___16.6гр_____//________________________//_________________________//____________________________//
//___________________//__________________________//___Помидоры__12.5гр____//___________________________//________________________//_________________________//____________________________//
//___________________//__________________________//_______________________//___________________________//________________________//_________________________//____________________________//
//Блин_Куриный__145гр//Блин_Буженина_и_сыр__145гр//__Блин_Богатырь_150гр__//______Маргарита_145гр______//________________________//___Блин_Яблочный_145гр___//____________________________//
//___________________//__________________________//_______________________//___________________________//________________________//_________________________//____________________________//
//__Тесто____100гр___//____Тесто________100гр____//___Тесто_______100гр___//_____Тесто_______100гр_____//________________________//Тесто____________100гр___//____________________________//
//__Сыр_______15гр___//____Сыр_________22.5гр____//___Сыр________16.6гр___//_____Сыр________16.6гр_____//________________________//Абрикосовый_джем__45гр___//____________________________//
//__Курицы____15гр___//____Буженина____22.5гр____//___Буженина___16.6гр___//_____Помидоры___22.5гр_____//________________________//_________________________//____________________________//
//__Помидоры__15гр___//__________________________//___Огурцы_____16.6гр___//___________________________//________________________//_________________________//____________________________//
//___________________//__________________________//_______________________//___________________________//________________________//_________________________//____________________________//

--[                                                                                    d o b a v k a                                                                                     ]--
--1                                                                                 Буженина | Pork ham                                                                                   --
--2                                                                                  Ветчина | Ham                                                                                        --
--3                                                                                  Индейка | Turkey                                                                                     --
--4                                                                       Малосольные огурцы | Lightly salted cucumbers                                                                   --
--5                                                                              Твердый сыр | Hard cheese                                                                                --
--6                                                                                  Лук фри | Onion fries                                                                                --
--7                                                                         Протертые томаты | Puree tomatoes                                                                             --
--8                                                                            Яблочный джем | Apple jam                                                                                  --
--9                                                                         Абрикосовый джем | Apricot jam                                                                                --
--10                                                                           Вишневый джем | Cherry jam                                                                                 --

--[                                                                                     d o p i n g                                                                                      ]--
--1                                                                                   Кетчуп | Ketchup                                                                                    --
--2                                                                                   Моенез | Moenes                                                                                     --
--3                                                                                  Сметана | Sour cream                                                                                 --
--4                                                                       Кисло-сладкий соус | Sweet and sour sauce                                                                       --
--5                                                                                  Горчица | Mustard                                                                                    --

network = {}

dobavka_list_CoSaB = {1,2,3,4,5,6,7,11,12,13,14}
dobavka_list_CoSwB = {8,9,10,15}
dobavka_list_SaB = {11,12,13,14}
dobavka_list_SwB = {15}

sleep_screen_localization = {
    screen_one = {
        Russian = {
            text_one = "Вкусный блин",
            text_two = "за 3 минуты!",
            text_three = "Нажмите, чтобы заказать блин",
        },
        English = {
            text_one = "Delicious pancake",
            text_two = "in 3 minutes!",
            text_three = "Click to order a pancake",
        },
        German = {
            text_one = "Köstlicher Pfannkuchen",
            text_two = "in 3 Minuten!",
            text_three = "Klicken Sie hier, um einen Pfannkuchen zu bestellen",
        },
    },
    screen_two = {
        Russian = {
            text_one = "БЛИНЫ",
            text_two = "и все такое",
        },
        English = {
            text_one = "PANCAKES",
            text_two = "and all that",
        },
        German = {
            text_one = "CREPES",
            text_two = "und das alles",
        },
    },
    screen_three = {
        Russian = {
            text_one = {
                "ПЕРВЫЙ",
                "БЛИН-",
                "НЕКОМОМ",
            },
        },
        English = {
            text_one = {
                "THE FIRST",
                "PANCAKE-",
                "IS UNKNOWN",
            },
        },
        German = {
            text_one = {
                "DER ERSTE",
                "CREPES-",
                "GEMEINNÜTZIGKEIT",
            }, 
        },
    },
}

blindozer_info_tab_localization = {
    Russian = {
        Title = "Ваш заказ",
        Description = {
            "Масса: ",
            "Калорийность: ",
            "Состав: "
        },
        Description_2 = {
            "Пищевая ценность",
            "Белки: ",
            "Жиры: ",
            "Углеводы: ",
        },
        Notification = "Пока блин без начинки. Отметьте, что туда положить:",
    },
    English = {
        Title = "Your Order",
        Description = {
            "Weight: ",
            "Calories: ",
            "Ingredients: "
        },
        Description_2 = {
            "Nutritional Value",
            "Proteins: ",
            "Fats: ",
            "Carbohydrates: ",
        },
        Notification = "So far, the pancake has no filling. Mark what to put there:",
    },
    German = {
        Title = "Ihre Bestellung",
        Description = {
            "Gewicht: ",
            "Kalorien: ",
            "Zutaten: "
        },
        Description_2 = {
            "Nährwert",
            "Eiweiße: ",
            "Fette: ",
            "Kohlenhydrate: ",
        },
        Notification = "Während der Pfannkuchen ohne Füllung ist. Markieren Sie, was Sie dort hinlegen sollen:",
    },
}

bler_addother = {
    [1] = {
        Localization = {
            Russian = "Буженина",
            English = "Roasted Pork",
            German = "Gebratenes Schweinefleisch"
        },
        Calories = 40.17,  
        Squirrels = 4.32,  
        Fats = 2.49,      
        Carbohydrates = 0,
        Price = 35 
    },
    [2] = {
        Localization = {
            Russian = "Ветчина",
            English = "Ham",
            German = "Schinken"
        },
        Calories = 24.07,  
        Squirrels = 2.99,   
        Fats = 1.16,        
        Carbohydrates = 0.17,
        Price = 35 
    },
    [3] = {
        Localization = {
            Russian = "Индейка",
            English = "Turkey",
            German = "Truthahn"
        },
        Calories = 31.37,  
        Squirrels = 4.81,  
        Fats = 1.16,    
        Carbohydrates = 0,
        Price = 35   
    },
    [4] = {
        Localization = {
            Russian = "Малосольные огурцы",
            English = "Lightly Salted Cucumbers",
            German = "Leicht gesalzene Gurken"
        },
        Calories = 1.99,  
        Squirrels = 0.10,  
        Fats = 0.02,       
        Carbohydrates = 0.37,
        Price = 35 
    },
    [5] = {
        Localization = {
            Russian = "Твердый сыр",
            English = "Hard Cheese",
            German = "Hartkäse"
        },
        Calories = 66.73,  
        Squirrels = 4.15,  
        Fats = 5.48,       
        Carbohydrates = 0.22,
        Price = 35 
    },
    [6] = {
        Localization = {
            Russian = "Лук фри",
            English = "Fried Onions",
            German = "Frittierte Zwiebeln"
        },
        Calories = 67.56,  
        Squirrels = 0.75,  
        Fats = 3.65,       
        Carbohydrates = 7.47,
        Price = 35
    },
    [7] = {
        Localization = {
            Russian = "Протертые томаты",
            English = "Tomato Puree",
            German = "Tomatenmark"
        },
        Calories = 13.61,  
        Squirrels = 0.71,  
        Fats = 0.08,       
        Carbohydrates = 2.99,
        Price = 35
    },
    [8] = {
        Localization = {
            Russian = "Яблочный джем",
            English = "Apple Jam",
            German = "Apfelmarmelade"
        },
        Calories = 43.99,  
        Squirrels = 0.07,  
        Fats = 0.02,      
        Carbohydrates = 11.45,
        Price = 35 
    },
    [9] = {
        Localization = {
            Russian = "Абрикосовый джем",
            English = "Apricot Jam",
            German = "Aprikosenmarmelade"
        },
        Calories = 40.17, 
        Squirrels = 0.10,  
        Fats = 0.03,       
        Carbohydrates = 10.29,
        Price = 35
    },
    [10] = {
        Localization = {
            Russian = "Вишневый джем",
            English = "Cherry Jam",
            German = "Kirschmarmelade"
        },
        Calories = 43.66,  
        Squirrels = 0.07,  
        Fats = 0.02,       
        Carbohydrates = 11.29,
        Price = 35 
    },
    [11] = {
        Localization = {
            Russian = "Майонез",
            English = "Mayonnaise",
            German = "Mayonnaise"
        },
        Calories = 112.88, 
        Squirrels = 0.18,  
        Fats = 12.45,    
        Carbohydrates = 0.10, 
        Price = 35
    },
    [12] = {
        Localization = {
            Russian = "Кетчуп",
            English = "Ketchup",
            German = "Ketchup"
        },
        Calories = 18.43,  
        Squirrels = 0.20, 
        Fats = 0.02,      
        Carbohydrates = 4.48,
        Price = 35 
    },
    [13] = {
        Localization = {
            Russian = "Горчица",
            English = "Mustard",
            German = "Senf"
        },
        Calories = 10.96, 
        Squirrels = 0.73,  
        Fats = 0.55,      
        Carbohydrates = 0.73,
        Price = 35
    },
    [14] = {
        Localization = {
            Russian = "Кисло-сладкий соус",
            English = "Sweet and Sour Sauce",
            German = "Süß-saure Soße"
        },
        Calories = 24.90,  
        Squirrels = 0.08,  
        Fats = 0.03,       
        Carbohydrates = 6.14,
        Price = 35
    },
    [15] = {
        Localization = {
            Russian = "Сметана",
            English = "Sour Cream",
            German = "Saure Sahne"
        },
        Calories = 32.04,  
        Squirrels = 0.46,  
        Fats = 2.99,
        Carbohydrates = 0.60,
        Price = 35
    }
}

bler_menu = {
    [1] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/satisfying_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Собери СЫТНЫЙ БЛИН",
                Description = '(буженина, ветчина, индейка, маринованные огурцы, твердый сыр, ...)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - Просто блин, буженина, ветчина, индейка, маринованные твердый сыр, лук фри, протерые томаты. Соусы - кетчуп, горчица, кислосладкий соус, сметана.",
            },
            German = {
                Name = "Stelle einen HERZHAFTEN PFANNKUCHEN zusammen",
                Description = '(Schinken, Putenbrust, eingelegte Gurken, Hartkäse, ...)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Einfacher Pfannkuchen, Schinken, Putenbrust, eingelegter Hartkäse, Röstzwiebeln, pürierte Tomaten. Saucen - Ketchup, Senf, süß-saurer Sauce, Sauerrahm.",
            },
            English = {
                Name = "Create a HEARTY PANCAKE",
                Description = '(ham, turkey, pickles, hard cheese, ...)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - Just a pancake, ham, turkey, pickles, hard cheese, fried onions, pureed tomatoes. Sauces - ketchup, mustard, sweet and sour sauce, sour cream.",
            },
        },
        Weight = 100,
        Calories = 208,
        Squirrels = 5,
        Fats = 3,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 100,
    },
    [2] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/sweet_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Собери СЛАДКИЙ БЛИН",
                Description = '(яблочный джем, вишневый джем, абрикосовый джем)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - Просто блин, яблочный джем, вишневый джем, абрикосовый джем, сметана.",
            },
            German = {
                Name = "Stelle einen SÜSSEN PFANNKUCHEN zusammen",
                Description = '(Apfelmarmelade, Kirschmarmelade, Aprikosenmarmelade)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Einfacher Pfannkuchen, Apfelmarmelade, Kirschmarmelade, Aprikosenmarmelade, Sauerrahm.",
            },
            English = {
                Name = "Create a SWEET PANCAKE",
                Description = '(apple jam, cherry jam, apricot jam)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - Just a pancake, apple jam, cherry jam, apricot jam, sour cream.",
            },
        },
        Weight = 100,
        Calories = 208,
        Squirrels = 5,
        Fats = 3,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 100,
    },
    [3] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/simply_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Просто блин",
                Description = '(блин без начинки)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - Просто блин.",
            },
            German = {
                Name = "Einfacher Pfannkuchen",
                Description = '(Pfannkuchen ohne Füllung)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Einfacher Pfannkuchen.",
            },
            English = {
                Name = "Just a pancake",
                Description = '(pancake without filling)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - Just a pancake.",
            },
        },
        Weight = 100,
        Calories = 208,
        Squirrels = 5,
        Fats = 3,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 100,
    },
    [4] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/cheesy_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Сырный»",
                Description = '(сыр, соус на выбор)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - сыр.",
            },
            German = {
                Name = "Käse-Pfannkuchen",
                Description = '(Käse, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Käse.",
            },
            English = {
                Name = "Cheesy pancake",
                Description = '(cheese, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - cheese.",
            },
        },
        Weight = 100,
        Calories = 208,
        Squirrels = 5,
        Fats = 3,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 100,
    },
    [5] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/dutch_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Голандский»",
                Description = '(ветчина, лук фри, горчичный соус)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - ветчина, лук фри, горчичный соус.",
            },
            German = {
                Name = "Holländischer Pfannkuchen",
                Description = '(Schinken, Röstzwiebeln, Senfsauce)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Schinken, Röstzwiebeln, Senfsauce.",
            },
            English = {
                Name = "Dutch pancake",
                Description = '(ham, fried onions, mustard sauce)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - ham, fried onions, mustard sauce.",
            },
        },
        Weight = 150,
        Calories = 300,
        Squirrels = 12,
        Fats = 12,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 140,
    },
    
    [6] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/ham_and_cheese_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Буженина и сыр»",
                Description = '(буженина, сыр, соус на выбор по желанию)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - cыр, буженина.",
            },
            German = {
                Name = "Schinken und Käse Pfannkuchen",
                Description = '(Schinken, Käse, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Käse, Schinken.",
            },
            English = {
                Name = "Ham and cheese pancake",
                Description = '(ham, cheese, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - cheese, ham.",
            },
        },
        Weight = 145,
        Calories = 263,
        Squirrels = 11,
        Fats = 8,
        Carbohydrates = 32,
        Model = 'blin3',
        Price = 140,
    },
    
    [7] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/epic_hero_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Богатырь»",
                Description = '(буженина, сыр, огурцы соленые, соус на выбор по желанию)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - cыр, буженина, огурцы соленые.",
            },
            German = {
                Name = "Held Pfannkuchen",
                Description = '(Schinken, Käse, eingelegte Gurken, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Käse, Schinken, eingelegte Gurken.",
            },
            English = {
                Name = "Epic hero pancake",
                Description = '(ham, cheese, pickles, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - cheese, ham, pickles.",
            },
        },
        Weight = 150,
        Calories = 314,
        Squirrels = 12,
        Fats = 8,
        Carbohydrates = 32,
        Model = 'blin3',
        Price = 160,
    },

    [8] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/ham_and_cheese_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Ветчина и сыр»",
                Description = '(ветчина, сыр, соус на выбор по желанию)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - cыр, ветчина.",
            },
            German = {
                Name = "Schinken und Käse Pfannkuchen",
                Description = '(Schinken, Käse, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Käse, Schinken.",
            },
            English = {
                Name = "Ham and cheese pancake",
                Description = '(ham, cheese, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - cheese, ham.",
            },
        },
        Weight = 145,
        Calories = 263,
        Squirrels = 10,
        Fats = 9,
        Carbohydrates = 32,
        Model = 'blin3',
        Price = 140,
    },
    
    [9] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/vegetable_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Овощной»",
                Description = '(помидоры, соленые огурцы, соус на выбор)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - помидоры, соленые огурцы, соусы на выбор.",
            },
            German = {
                Name = "Gemüse-Pfannkuchen",
                Description = '(Tomaten, eingelegte Gurken, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Tomaten, eingelegte Gurken, Saucen nach Wahl.",
            },
            English = {
                Name = "Vegetable pancake",
                Description = '(tomatoes, pickles, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - tomatoes, pickles, sauces of choice.",
            },
        },
        Weight = 142,
        Calories = 232,
        Squirrels = 5,
        Fats = 7,
        Carbohydrates = 32,
        Model = 'blin3',
        Price = 140,
    },
    
    [10] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/chicken_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Куриный»",
                Description = '(курица, сыр пармезан, помидоры, соус на выбор по желанию)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - грудка куриная помидоры, сыр, соусы на выбор",
            },
            German = {
                Name = "Hühnchen-Pfannkuchen",
                Description = '(Hähnchen, Parmesan, Tomaten, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Hähnchenbrust, Tomaten, Käse, Saucen nach Wahl.",
            },
            English = {
                Name = "Chicken pancake",
                Description = '(chicken, parmesan cheese, tomatoes, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - chicken breast, tomatoes, cheese, sauces of choice.",
            },
        },
        Weight = 145,
        Calories = 334,
        Squirrels = 17,
        Fats = 13,
        Carbohydrates = 32,
        Model = 'blin3',
        Price = 160,
    },

    [11] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/margaret_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Маргарита»",
                Description = '(сыр, помидоры, соус на выбор по желанию)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - помидоры, сыр, соусы на выбор.",
            },
            German = {
                Name = "Margarita-Pfannkuchen",
                Description = '(Käse, Tomaten, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Tomaten, Käse, Saucen nach Wahl.",
            },
            English = {
                Name = "Margarita pancake",
                Description = '(cheese, tomatoes, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - tomatoes, cheese, sauces of choice.",
            },
        },
        Weight = 140,
        Calories = 290,
        Squirrels = 12,
        Fats = 10,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 150,
    },

    [12] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/picnic_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Пикник»",
                Description = '(ветчина, сыр, помидоры, огурцы соленые, соус на выбор по желанию)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - ветчина, сыр, огурцы солёные, помидоры.",
            },
            German = {
                Name = "Picknick-Pfannkuchen",
                Description = '(Schinken, Käse, Tomaten, eingelegte Gurken, Sauce nach Wahl)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Schinken, Käse, eingelegte Gurken, Tomaten.",
            },
            English = {
                Name = "Picnic pancake",
                Description = '(ham, cheese, tomatoes, pickles, sauce of choice)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - ham, cheese, pickles, tomatoes.",
            },
        },
        Weight = 140,
        Calories = 290,
        Squirrels = 12,
        Fats = 10,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 150,
    },

    [13] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/applesauce_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Яблочный»",
                Description = '(яблочный джем)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - яблочный джем.",
            },
            German = {
                Name = "Apfel-Pfannkuchen",
                Description = '(Apfelmarmelade)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Apfelmarmelade.",
            },
            English = {
                Name = "Apple pancake",
                Description = '(apple jam)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - apple jam.",
            },
        },
        Weight = 140,
        Calories = 290,
        Squirrels = 12,
        Fats = 10,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 150,
    },

    [14] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/cherry_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Вишневый»",
                Description = '(вишневый джем)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - вишневый джем.",
            },
            German = {
                Name = "Kirsch-Pfannkuchen",
                Description = '(Kirschmarmelade)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Kirschmarmelade.",
            },
            English = {
                Name = "Cherry pancake",
                Description = '(cherry jam)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - cherry jam.",
            },
        },
        Weight = 140,
        Calories = 290,
        Squirrels = 12,
        Fats = 10,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 150,
    },
    [15] = {
        Icon = 'materials/metrostroi_3demc/vending_machine_gui/position/apricot_pancake_position.png',
        Localization = {
            Russian = {
                Name = "Блин «Абрикосовый»",
                Description = '(абрикосовый джем)',
                Composition = "             Тесто - мука пшеничная, молоко, яйца, масло растительное, сахар, соль. Начинка - абрикосовый джем.",
            },
            German = {
                Name = "Aprikosen-Pfannkuchen",
                Description = '(Aprikosenmarmelade)',
                Composition = "             Teig - Weizenmehl, Milch, Eier, Pflanzenöl, Zucker, Salz. Füllung - Aprikosenmarmelade.",
            },
            English = {
                Name = "Apricot pancake",
                Description = '(apricot jam)',
                Composition = "                   Dough - wheat flour, milk, eggs, vegetable oil, sugar, salt. Filling - apricot jam.",
            },
        },
        Weight = 140,
        Calories = 290,
        Squirrels = 12,
        Fats = 10,
        Carbohydrates = 34,
        Model = 'blin3',
        Price = 150,
    },
}



////                                                                                                                                                                                  \\\\
/////////////////////////////////////////////////////////////////////////////////FUNCTION\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////                                                                                                                                                                                  \\\\



function windowOrderPurchase(self, mouseX, mouseY)
    draw.RoundedBoxEx(13,346,213,408,430,Color(225,179,53,255),true,true,true,true)
    
    local x = 360
    local y = 270
    local width = 377
    local hight = 79
    local buttons = {
        [1] = {
            Russian = "Наличные",
            German = "Bargeld",
            English = "Cash"
        },
        [2] = {
            Russian = "Банковская карта",
            German = "Bankkarte",
            English = "Bank card"
        },
        [3] = {
            Russian = "Промокод",
            German = "Gutscheincode",
            English = "Promo code"
        },
        [4] = {
            Russian = "Отмена",
            German = "Abbrechen",
            English = "Cancel"
        }
    }
    local logo_lon = {
        [1] = {
            Russian = "ВЫБЕРИТЕ СПОСОБ ОПЛАТЫ",
            German = "ZAHLUNGSMETHODE AUSWÄHLEN",
            English = "SELECT PAYMENT METHOD"
        }
    }

    draw.DrawText(logo_lon[1][self.language],"TitlePay",550,230,Color(0,0,0,255),TEXT_ALIGN_CENTER)
    for k,v in SortedPairs(buttons) do
        draw.RoundedBoxEx(13,x,y,width,hight,Color(216,216,216,255),true,true,true,true)
        
        if k != 4 and k != 5 then
            draw.DrawText(v[self.language],"TitlePay",550,y+24,Color(0,0,0,255),TEXT_ALIGN_CENTER)
        elseif k >= 4 and k < 5 then
            draw.DrawText(v[self.language],"TitlePay",550,y+24,Color(255,0,0,255),TEXT_ALIGN_CENTER)
        end
        button_click(x,y,width,hight,mouseX,mouseY,self,function()
            if k == 1 or k == 2 then
                local table_blinchik = {
                    name = self.position_allowed[self.clicked_position].Localization[self.language].Name,
                    сomposition = self.position_allowed[self.clicked_position].Localization[self.language].Composition,
                    massa = self.position_allowed[self.clicked_position].Weight,
                    calories = self.position_allowed[self.clicked_position].Calories,
                    squirrels = self.position_allowed[self.clicked_position].Squirrels,
                    fats = self.position_allowed[self.clicked_position].Fats,
                    carbohydrates = self.position_allowed[self.clicked_position].Carbohydrates
                }
                net.Start("Pay")
                    net.WriteTable(table_blinchik)
                net.SendToServer()
                ResetAllDobavki(self)
                self.clicked_position = nil
                self.current_page = 1
                self.order_purchase_window  = false
            elseif k == 4 then
                self.order_purchase_window  = false
            elseif k == 3 then
                --В разработке--
            end
            surface.PlaySound("gui/tuch.wav")
        end)
        y = y + 93
    end
end



function windowPositionInfo(self, mouseX, mouseY)
    
    DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/GUI_Blindozer_info_tab.png",0,0,self.WindowSizeX,self.WindowSizeY,nil)

    local buttons_system_localization = {
        Russian = {
            close = "Отмена",
            pay = "К оплате",
            const = 885,
            const2 = - 705
        },
        German = {
            close = "Schließen",
            pay = "Bezahlen",
            const = 900,
            const2 = - 710
        },
        English = {
            close = "Close",
            pay = "Pay",
            const = 855,
            const2 = - 765
        }
    }

    local patch = buttons_system_localization[self.language]
    DrawTextCenter("TheDefaultSettings1",Color(255, 0, 0, alpha),750,patch.close,patch.const,true,self)

    DrawTextCenter("TheDefaultSettings1",Color(255, 0, 0, alpha),750,patch.pay,patch.const2,true,self)
    AddDobavka(self,mouseX,mouseY,self.clicked_position) 
    if self.clicked_position then
            
        local clicked = self.position_allowed[self.clicked_position]
        DrawText("Title",Color(0, 0, 0,alpha),297,185,clicked.Localization[self.language].Name)

        DrawText("Title2",Color(0, 0, 0,alpha),297,215,clicked.Localization[self.language].Name)

        DrawImageToColor(clicked.Icon,40,180,236,290,nil)

        DrawText("TitleS",Color(0, 0, 0,alpha),40,96,blindozer_info_tab_localization[self.language].Title)

        local x = 297
        local y = 257
        for _, BITLV in SortedPairs(blindozer_info_tab_localization[self.language].Description) do

            DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),x,y,BITLV)
            y = y + 45

        end

        local x1 = 450
        DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),x1,257,clicked.Weight.. ' g')

        DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),x1,302,clicked.Calories.. ' kkal')

        drawWrappedText(clicked.Localization[self.language].Composition, "blindozer_info_tab_localization", 297, 347, 500, 30)
        
        local y = 257
        for BITLK, BITLV in SortedPairs(blindozer_info_tab_localization[self.language].Description_2) do

            if BITLK == 1 then

                DrawText("blindozer_info_tab_localization2",Color(0, 0, 0,alpha),860,y,BITLV)

            else

                DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),860,y,BITLV)

            end
            y = y + 45

        end

        DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),970,302,clicked.Squirrels.. " kDa")

        DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),970,347,clicked.Fats.. " kkal")

        DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),970,392,clicked.Carbohydrates.. " g")

        local function hasTrueValue(table)
            for _, value in pairs(table) do
                if value == true then
                    return true
                end
            end
            return false
        end
        
        if self.clicked_position == 1 or self.clicked_position == 2 then
            if not hasTrueValue(self.buttonStates) then 
                DrawText("blindozer_info_tab_localization", Color(255, 0, 0, alpha), 40, 520, blindozer_info_tab_localization[self.language].Notification)
            end
        else
            DrawTextCenter("TheDefaultSettings",Color(212,212,212),809,"*ВНЕШНИЙ ВИД ГОТОВОГО ПРОДУКТА МОЖЕТ ОТЛИЧАТЬСЯ ОТ ИЗОБРАЖЕНИЯ*",0,false,self)
        end
        DrawText("blindozer_info_tab_localization",Color(0, 0, 0,alpha),970,392,"")
    end  
    
    if self.order_purchase_window then
        windowOrderPurchase(self, mouseX, mouseY)
    end
end



function create_menu_position(Xmin, Ymin, element, element_key, mouseX, mouseY, self)
    local width, height = 236, 290  
    DrawImageToColor(element.Icon,Xmin,Ymin,width,height,nil)

    surface.SetTextColor(0, 0, 0)
    surface.SetFont("TheDefaultSettings")

///_____________________________________________________________________________________TEXT_NAME_____________________________________________________________________________________________///
    local text = element.Localization[self.language].Name
    local wrappedText = WrapText(text, 220)  
    local textHeight = #wrappedText * 18
    local textX = Xmin + (236.68 - surface.GetTextSize(wrappedText[1] or "") ) / 2 
    local textY = Ymin + 180
    local currentY = textY
    for _, line in ipairs(wrappedText) do
        local lineWidth, _ = surface.GetTextSize(line)  
        local lineX = Xmin + (236.68 - lineWidth) / 2
        surface.SetTextColor(0, 0, 0) 
        surface.SetTextPos(lineX, currentY)
        surface.DrawText(line)          
        currentY = currentY + 20
    end

///________________________________________________________________________________TEXT_DESCRIPTION___________________________________________________________________________________________///
    local text1 = element.Localization[self.language].Description
    local wrappedText = WrapText(text1, 210) 
    local lineHeight = 20 
    local currentY = textY + textHeight + 10 
    for _, line in ipairs(wrappedText) do
        local lineWidth, _ = surface.GetTextSize(line) 
        local lineX = Xmin + (236.68 - lineWidth) / 2  
        surface.SetTextColor(78, 78, 78)
        surface.SetTextPos(lineX, currentY)
        surface.DrawText(line)
        currentY = currentY + lineHeight
    end

///___________________________________________________________________________________TEXT_PRICE______________________________________________________________________________________________///
    if element_key < 3 then
       
        DrawText("TheDefaultSettings1",Color(255, 255, 255,alpha),Xmin + 10,Ymin,"от")
        
        DrawText("TheDefaultSettings1",Color(255, 255, 255,alpha),Xmin + 10,Ymin + 20,element.Price.."р")

    elseif element_key < 5 then

        DrawText("TheDefaultSettings1",Color(255, 255, 255,alpha),Xmin + 10,Ymin + 5,element.Price.."р")

    else

        DrawText("TheDefaultSettings1",Color(255, 255, 255,alpha),Xmin + 10,Ymin + 5,element.Price.."р")
        
    end

    button_click(Xmin, Ymin, width, height, mouseX, mouseY, self, function()
        self.clicked_position = element_key
        surface.PlaySound("gui/tuch.wav")
    end) 
end

function windowPositionMenu(self, mouseX, mouseY)
    
    self.current_page = self.current_page or 1

    if self.language == "Russian" then
        DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/RU_VERSION_GUI_BLINDOZER.png", 0, 0, 1100, 856, nil)
        DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/RU_GUI_NEXT_BUTTON.png", 807, 65, 251.66, 64, nil)

        button_click(807, 65, 251.66, 64, mouseX, mouseY, self, function()
            self.current_page = self.current_page + 1
            if self.current_page > math.ceil(table.Count(bler_menu) / 8) then
                self.current_page = 1
            end
            surface.PlaySound("gui/tuch.wav")
        end)

    elseif self.language == "English" then
        DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/ENG_VERSION_GUI_BLINDOZER.png", 0, 0, 1100, 856, nil)
        DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/ENGandGER_GUI_NEXT_BUTTON.png", 839, 116, 220, 30, nil)

        button_click(839, 116, 220, 30, mouseX, mouseY, self, function()
            self.current_page = self.current_page + 1
            if self.current_page > math.ceil(table.Count(bler_menu) / 8) then
                self.current_page = 1
            end
            surface.PlaySound("gui/tuch.wav")
        end)

    elseif self.language == "German" then
        DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/GER_VERSION_GUI_BLINDOZER.png", 0, 0, 1100, 856, nil)
        DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/ENGandGER_GUI_NEXT_BUTTON.png", 839, 116, 220, 30, nil)

        button_click(839, 116, 220, 30, mouseX, mouseY, self, function()
            self.current_page = self.current_page + 1
            if self.current_page > math.ceil(table.Count(bler_menu) / 8) then
                self.current_page = 1
            end
            surface.PlaySound("gui/tuch.wav")
        end)
    end

    local language_table = {
        "Russian",
        "German",
        "English",
    }
    local x = 911
    for l, m in SortedPairs(language_table) do
        button_click(x, 801, 42.05, 19, mouseX, mouseY, self, function()
            self.language = m
            surface.PlaySound("gui/tuch.wav")
        end)
        x = x + 53
    end

    local element_count = 0
    local max_elements = 8
    local start_index = (self.current_page - 1) * max_elements + 1
    local end_index = self.current_page * max_elements

    for a, b in SortedPairs(bler_menu) do
        if element_count >= max_elements then
            break
        end
        if a >= start_index and a <= end_index then
            local pos_allowed = true
            if pos_allowed then
                element_count = element_count + 1
                self.position_allowed[a] = b
                if element_count > 4 then
                    Ymin = 495
                    Xmin = 39 + (element_count - 5) * 261
                else
                    Xmin = 39 + (element_count - 1) * 261
                    Ymin = 187
                end
                create_menu_position(Xmin, Ymin, b, a, mouseX, mouseY, self)
            end
        end
    end
end



function preset_gui_sleep_screen_one(self) 

    DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/preset_gui_sleep_1.png",326,390,449,265,nil)

    DrawTextCenter("gui_sleep_screen",Color(0, 0, 0, alpha),203,sleep_screen_localization.screen_one[self.language].text_one,0,false,self)

    DrawTextCenter("gui_sleep_screen1",Color(0, 0, 0, alpha),270,sleep_screen_localization.screen_one[self.language].text_two,0,false,self)
    
end 

function preset_gui_sleep_screen_two(self) 

    DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/preset_gui_sleep_2.png",52,210,231,431,nil)

    local y = 203
    for i = 1, 2 do 

        DrawTextCenter("gui_sleep_screenV2",Color(0, 0, 0, alpha),y,sleep_screen_localization.screen_two[self.language].text_one,0,false,self)
        y = y + 221 

    end
    local y = 310
    for i = 1, 2 do 

        DrawTextCenter("gui_sleep_screen",Color(0, 0, 0, alpha),y,sleep_screen_localization.screen_two[self.language].text_one,0,false,self)
        y = y + 221

    end

    local y = 640
    DrawTextCenter("gui_sleep_screen2",Color(0, 0, 0, alpha),y,sleep_screen_localization.screen_two[self.language].text_two,795,false,self)

end

function preset_gui_sleep_screen_three(self) 

    DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/preset_gui_sleep_3.png",815,210,231,431,nil)

    local y = 250
    for _, PGSV in ipairs(sleep_screen_localization.screen_three[self.language].text_one) do
        DrawTextCenter("gui_sleep_screen3",Color(217, 217, 217, alpha),y,PGSV,1000,true,self)
        y = y + 100 
    end

end

function preset_gui_sleep_screen_text_3(self)
    DrawTextCenter("gui_sleep_screen2",Color(0,0,0,alpha),722,sleep_screen_localization.screen_one[self.language].text_three,0,false,self)
end

function window_screen_sleep(self)
    DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/BR_Gui_Sleep.png",0,0,self.WindowSizeX,self.WindowSizeY,nil)

    if self.currentScreen == 1 then

        preset_gui_sleep_screen_one(self)

    elseif self.currentScreen == 2 then

        preset_gui_sleep_screen_two(self)

    elseif self.currentScreen == 3 then

        preset_gui_sleep_screen_three(self)

    end
    preset_gui_sleep_screen_text_3(self)
end



function windowSystem_Start(self)
    local symbols = {
        "Blindozer Modular System v1.00PT",
        "Copyright (C) 2015 - 2025, Blindozer Software, Inc.",
        "B00XP-UD8 F2",
        "",
        "Main Processor : MCST Elbrus(R) - 8СВ CPU 1.5GHz",
        "<CPUID: 0".. self:GetNWInt("owner") .. "0 Patch ID: 0".. self:EntIndex() .."026>",
        "Memory Testing: Ok",
        "",
        "Detected ATA/ATAPI Devices...",
        "SATA Port1: SSDRedStar0043AS",
        "SATA Port2: None",
        "SATA Port3: None",
        "",
        "Detected USB Devices...",
        "USB Port1: none",
        "USB Port2: none",
        "USB Port3: none",
        "",
        "Detected Enternet Devices...",
        "Enternet Port1: none",
        "Enternet Port2: none",
        "Enternet Port3: none",
        "Ready....",
    } 

    if self.currentLine <= #symbols and not self.system_start then
        if not self.timer then
            self.timer = true
            local entity = self
            timer.Create("NextLineTimer_" .. self:EntIndex(), self.delayBetweenLines, 1, function()
                if IsValid(entity) then 
                    table.insert(entity.lines, symbols[entity.currentLine])
                    entity.currentLine = entity.currentLine + 1
                    self.delayBetweenLines = math.random( 0 , 1) 
                    self.language = self.settings.setting2 or "Russian"
                    entity.timer = false
                end
            end)
        end 
    elseif self.currentLine >= #symbols and not self.system_start then
        timer.Simple(5,function()
            self.system_start = true
        end)
    elseif self.system_start and self.gui_sleep_screen then
        if CurTime() > self.screenChangeTime then
            self.currentScreen = self.currentScreen + 1
            if self.currentScreen > 3 then
                self.currentScreen = 1 -- Возвращаемся к первому экрану после третьего
            end
            self.screenChangeTime = CurTime() + 10 -- Устанавливаем время для следующей смены экрана
        end
    end

    
    DrawImageToColor("materials/metrostroi_3demc/vending_machine_gui/BR_Gui_Loading.png",0,0,self.WindowSizeX,self.WindowSizeY,nil)

    local startX = 67
    local startY = 62
    for i, line in ipairs(self.lines) do
        DrawText("System_Loadings",Color(255, 255, 255, alpha),startX, startY + (i - 1) * self.lineHeight,line)
    end
end



function DrawImageToColor(Image,x,y,SizeX,SizeY,Color)

    if Image != nil then
        surface.SetMaterial(Material(Image))
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect(x, y, SizeX, SizeY)
    elseif Color != nil then
        surface.SetDrawColor(Color)
        surface.DrawRect(x, y, SizeX, SizeY)
    end

end

function DrawTextCenter(font,color,y,text,const,bool,self)

    surface.SetFont(font)
    local text1 = text
    local const = const or 0
    local bool = bool or false
    local text1Width, text1Height = surface.GetTextSize(text)
    local text1X
        if bool then
            text1X = (self.WindowSizeX - const) / 2
        else
            text1X = (self.WindowSizeX + const - text1Width) / 2
        end
    surface.SetTextColor(color)
    surface.SetTextPos(text1X, y) 
    surface.DrawText(text)

end

function DrawText(font,color,x,y,text)
    surface.SetFont(font)
    surface.SetTextColor(color)
    surface.SetTextPos(x, y) 
    surface.DrawText(text)
end

function WrapText(text, maxWidth)
    local words = string.Explode(" ", text)  
    local lines = {}
    local currentLine = ""

    for _, word in ipairs(words) do
        local testLine = currentLine .. (currentLine == "" and "" or " ") .. word
        local textWidth, _ = surface.GetTextSize(testLine)

        if textWidth <= maxWidth then
            currentLine = testLine
        else
            table.insert(lines, currentLine)  
            currentLine = word 
        end
    end

    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    return lines
end   

//_______________________________________________________________________________________BUTTON_CLICK__________________________________________________________________________________________//



function button_click(x,y,width,hight,mouseX,mouseY,self,onClickFunction)
    local Xmax = x + width
    local Ymax = y + hight
    local trace = LocalPlayer():GetEyeTrace()
    if mouseX > x and mouseX < Xmax and mouseY > y and mouseY < Ymax then
        if trace.Entity == self and LocalPlayer():GetNWBool("isUsingEntity") then
            if input.IsMouseDown(MOUSE_LEFT) then
                gui.InternalMouseReleased(MOUSE_LEFT)
                onClickFunction()
            end          
        end
    end
end

//_____________________________________________________________________________________________________________________________________________________________________________________________//

function drawWrappedText(text, font, x, y, maxWidth, lineHeight)
    surface.SetFont(font)
    local words = string.Explode(" ", text)
    local currentLine = ""
    local currentY = y

    for _, word in ipairs(words) do
        local testLine = currentLine .. " " .. word
        local testWidth = surface.GetTextSize(testLine)

        if testWidth <= maxWidth then
            currentLine = testLine
        else
            surface.SetTextPos(x, currentY)
            surface.DrawText(currentLine)
            currentY = currentY + lineHeight
            currentLine = word
        end
    end

    surface.SetTextPos(x, currentY)
    surface.DrawText(currentLine)
end

function ScrollerButton(x, self)
    local trace = LocalPlayer():GetEyeTrace()
    if trace.Entity == self and LocalPlayer():GetNWBool("isUsingEntity") then
        if input.IsKeyDown(KEY_LEFT) then
            self.scrollOffset = self.scrollOffset - self.scrollSpeed
        elseif input.IsKeyDown(KEY_RIGHT) then
            self.scrollOffset = self.scrollOffset + self.scrollSpeed
        end
        self.scrollOffset = math.max(0, math.min(self.scrollOffset, x))
    end
end

function DrawRectRadius(x, y, radius, width, height, color,bool,bool1,bool2,bool3,bool4,const,color2)
    draw.RoundedBoxEx(radius, x, y, width, height, color,bool,bool1,bool2,bool3)
    if bool4 then
        draw.RoundedBoxEx(radius*0.6, x+(const/2), y+(const/2), width-const, height-const, color2,bool,bool1,bool2,bool3)
    end
end



function AddDobavka(self, mouseX, mouseY)
    local x = 40 - self.scrollOffset
    local y = 580  
    local x1 = 40 - self.scrollOffset
    local y1 = 655

    render.SetStencilEnable(true)
    render.ClearStencil()
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)

    DrawImageToColor(nil, 40, 580, 1024, 130, Color(220, 220, 220, alpha))

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilPassOperation(STENCILOPERATION_KEEP)
    
    self.buttonStates = self.buttonStates or {}

    local function DrawButton(buttonX, buttonY, BAK, BAV)
        local standardButtonWidth = 220 
        local buttonWidth 
        local text = BAV.Localization[self.language]
        local priceText = BAV.Price
        local textWidth = surface.GetTextSize(text)
        local priceTextWidth = surface.GetTextSize(priceText)
        local maxTextWidth = math.max(textWidth, priceTextWidth)
        
        if maxTextWidth + 130 > standardButtonWidth then
            buttonWidth = maxTextWidth + 130  
        else
            buttonWidth = standardButtonWidth 
        end 

        function UpdateBlinNutrition(self, BAV, isAdding)
            local multiplier = isAdding and 1 or -1
            local blin = self.position_allowed[self.clicked_position]
            local BAV_Calories = BAV.Calories
            local BAV_Carbohydrates = BAV.Carbohydrates
            local BAV_Fats = BAV.Fats
            local BAV_Squirrels = BAV.Squirrels
            blin.Calories = blin.Calories + multiplier * BAV.Calories
            blin.Carbohydrates = blin.Carbohydrates + multiplier * BAV.Carbohydrates
            blin.Fats = blin.Fats + multiplier * BAV.Fats
            blin.Squirrels = blin.Squirrels + multiplier * BAV.Squirrels
            blin.Weight = blin.Weight + multiplier * 16.6
        end
        if not self.order_purchase_window  then
            button_click(buttonX, buttonY, buttonWidth, 55, mouseX, mouseY, self, function() -- выбор допингов
                self.buttonStates[BAK] = not self.buttonStates[BAK]
                UpdateBlinNutrition(self, BAV, self.buttonStates[BAK])
                surface.PlaySound("gui/tuch.wav")
            end)
        end

        DrawRectRadius(buttonX, buttonY, 13, buttonWidth, 55, Color(195, 195, 195, 255), true, true, true, true, true, 8, Color(220, 220, 220, 255))
        
        DrawText("blindozer_info_tab_localization", Color(0, 0, 0, alpha), buttonX + 80, buttonY + 2, text)
        DrawText("blindozer_info_tab_localization", Color(0, 0, 0, alpha), buttonX + 80, buttonY + 24, "(" .. priceText .. "р)")

        if self.buttonStates[BAK] then
            surface.SetMaterial(Material("materials/metrostroi_3demc/vending_machine_gui/preset_gui_Check.png"))
            surface.DrawTexturedRect(buttonX + 20, buttonY, 55, 55)
        end
        
        if self.clicked_position == nil then
            self.buttonStates[BAK] = false
        end

        return buttonWidth
    end

    if not self.order_purchase_window  then
        button_click(39, 740, 223, 46, mouseX, mouseY, self, function()
            ResetAllDobavki(self)
            self.current_page = 1
            self.clicked_position = nil
            if self.order_purchase_window then
                self.order_purchase_window = false
            end
            surface.PlaySound("gui/tuch.wav")
        end)
    end

    self.addother = {}
    if self.clicked_position ~= nil then
        if self.clicked_position == 1 then
            self.addother = self.dobavka_list_CoSaB
        elseif self.clicked_position == 2 then
            self.addother = self.dobavka_list_CoSwB 
        elseif self.clicked_position > 2 and self.clicked_position < 13 then
            self.addother = self.dobavka_list_SaB
        elseif self.clicked_position > 12 then
            self.addother = self.dobavka_list_SwB
        end
    end
    for BAK, BAV in SortedPairs(self.bler_addother) do
        for _, v in SortedPairs(self.addother) do
            if v == BAK then
                if BAK < 11 then
                    local buttonWidth = DrawButton(x, y, BAK, BAV)
                    x = x + buttonWidth + 20
                elseif BAK > 10 then
                    local buttonWidth = DrawButton(x1, y1, BAK, BAV)
                    x1 = x1 + buttonWidth + 20
                end
            end
        end
    end

    local maxX = math.max(x - 180, x1 - 1020)
    ScrollerButton(maxX, self)

    render.SetStencilEnable(false)
    
    if not self.order_purchase_window  then
        button_click(840, 740, 223, 46, mouseX, mouseY, self, function()
            self.order_purchase_window = true
            surface.PlaySound("gui/tuch.wav")
        end)
    end
end

function ResetAllDobavki(self)
    for BAK, isActive in pairs(self.buttonStates) do
        if isActive then
            local BAV = self.bler_addother[BAK]
            UpdateBlinNutrition(self, BAV, false)
            self.buttonStates[BAK] = false
        end
    end
end



////                                                                                                                                                                                  \\\\
/////////////////////////////////////////////////////////////////////////////////FUNCTION\END\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////                                                                                                                                                                                  \\\\



function ENT:Draw()

    if not IsValid(self) then return end
    self:DrawModel()    
    local pos, ang = self:LocalToWorld(Vector(9.2, -16.63, 65.5)), self:GetAngles()
    local dist = LocalPlayer():EyePos():Distance(self:GetPos())

    local viewdist = tonumber(self.settings.setting1) or 170
    local viewdistmax = viewdist
    local viewdistmin = viewdist * 0.80

    local alpha = 0

    if dist < viewdistmin then
        alpha = 255
    elseif dist > viewdistmax then
        alpha = 0 
    else
        alpha = 255 * (1 - (dist - viewdistmin) / (viewdistmax - viewdistmin))
    end

    if alpha > 0 then
        cam.Start3D2D(pos, ang + Angle(0, 0, 90), 0.017)

            DrawImageToColor(nil,0,0,self.WindowSizeX,self.WindowSizeY,Color(248, 248, 248, alpha))

            if not self.system_start then

                windowSystem_Start(self)

            end

            if self.system_start then

                local mouseX, mouseY = gui.MouseX(), gui.MouseY()
                local screenX = self.WindowSizeX * 0.5
                local screenY = self.WindowSizeY * 0.5
                mouseX = mouseX - (ScrW() * 0.5) + screenX
                mouseY = mouseY - (ScrH() * 0.5) + screenY

                if self.gui_sleep_screen then

                    window_screen_sleep(self)

                elseif not self.gui_sleep_screen and not self.clicked_position then

                    self.current_page = self.current_page or 1 
                    windowPositionMenu(self, mouseX, mouseY)

                elseif not self.gui_sleep_screen and self.clicked_position then

                    windowPositionInfo(self, mouseX, mouseY)
                    
                end

                if LocalPlayer():GetNWBool("isUsingEntity") and LocalPlayer():GetEyeTrace().Entity == self then
                    if mouseX ~= self.lastMouseX or mouseY ~= self.lastMouseY then
                        self.lastMouseMove = CurTime()
                        self.lastMouseX, self.lastMouseY = mouseX, mouseY
                    end
                    
                    if mouseX > 30 and mouseX < 1070 and mouseY > 30 and mouseY < 820 then
                        
                        surface.SetDrawColor(129, 129, 129, 255)
                        surface.DrawCircle(mouseX, mouseY, 15 + math.sin(CurTime() * 5) * 2, Color(255, 0, 0))
                        
                        button_click( 30, 30, 1040, 790, mouseX, mouseY, self, function()
                            if self.gui_sleep_screen then
                                self.gui_sleep_screen = false
                                surface.PlaySound("gui/tuch.wav")
                            end
                        end)
                    end
                end

                if CurTime() - self.lastMouseMove >= 120 then
                    self.current_page = 1
                    self.gui_sleep_screen = true
                    self.clicked_position = nil
                    self.order_purchase_window  = false
                end
            end
        cam.End3D2D()
    end
end

function ENT:OnRemove()
    timer.Remove("NextLineTimer_" .. self:EntIndex())
end
