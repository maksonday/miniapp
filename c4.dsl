workspace {
    !identifiers hierarchical


    model {
        
        customer = person "Пользователь"
        
        app = softwareSystem "Онлайн Магазин" {
            wa = container "Application" {
                tags "App"
                
                
                auth = component "Auth Service" {
                    technology "Golang app"
                }
                user = component "Users Service" {
                    technology "Golang app"
                }
                stock = component "Stock Service" {
                    technology "Golang app"
                }
                billing = component "Billing Service" {
                    technology "Golang app"
                }
                order = component "Order Service" {
                    technology "Golang app"
                }
                notifications = component "Notifications Service" {
                    technology "Golang app"
                }
                delivery = component "Delivery Service" {
                    technology "Golang app"
                }
                
                user -> auth "[GET] /refresh_token", "REST/HTTP"
                billing -> auth "[GET] /refresh_token", "REST/HTTP"
                stock -> auth "[GET] /refresh_token", "REST/HTTP"
                order -> auth "[GET] /refresh_token", "REST/HTTP"
                notifications -> auth "[GET] /refresh_token", "REST/HTTP"
                delivery -> auth "[GET] /refresh_token", "REST/HTTP"
            }
            
            pg = container "PostgreSQL" {
                tags "Database"
            }
            
            redis = container "Redis" {
                tags "Database"
            }
            
            kafka = container "Kafka" {
                tags "Queue"

                stock_changes = component "Stock Changes" {
                    technology "Kafka Topic"
                }

                stock_changes_status = component "Stock Changes Status" {
                    technology "Kafka Topic"
                }

                payments = component "Payments" {
                    technology "Kafka Topic"
                }

                payments_status = component "Payments Status" {
                    technology "Kafka Topic"
                }

                cour_reserve = component "Courier Reserve" {
                    technology "Kafka Topic"
                }

                cour_reserve_status = component "Courier Reserve Status" {
                    technology "Kafka Topic"
                }

                notifications = component "Notifications" {
                    technology "Kafka Topic"
                }
            }

            wa -> kafka "Event Streams"

            wa.auth -> pg "Создание пользователей"
            wa.auth -> redis "Put tokens to BlackList"
            redis -> wa.auth "Get Token Blacklist(check logout)"

            wa.user -> pg "Изменение пользователей"
            pg -> wa.user "Получение данных пользователей"
            redis -> wa.user "Get Token Blacklist(check logout)"

            wa.billing -> pg "Изменение баланса и обработка платежных событий"
            pg -> wa.billing "Проверка состояний событий и баланса"
            redis -> wa.billing "Get Token Blacklist(check logout)"

            wa.stock -> pg "Изменение склада и обработка событий изменения склада"
            pg -> wa.stock "Проверка состояний событий и склада"
            redis -> wa.stock "Get Token Blacklist(check logout)"

            wa.order -> pg "Создание заказов и генерация событий для склада, биллинга, доставки и уведомлений"
            pg -> wa.order "Проверка состояний событий и заказа"
            redis -> wa.order "Get Token Blacklist(check logout)"

            pg -> wa.notifications "Получение списка уведомлений, отправленных пользователю"
            redis -> wa.notifications "Get Token Blacklist(check logout)"

            wa.delivery -> pg "Добавление курьеров и обработка событий резерва курьеров"
            pg -> wa.delivery "Проверка состояний событий"
            redis -> wa.delivery "Get Token Blacklist(check logout)"


            wa.order -> kafka.stock_changes "Создание событий изменений склада"
            kafka.stock_changes -> wa.stock "Обработка событий"
            wa.stock -> kafka.stock_changes_status "Отправка статуса событий"
            kafka.stock_changes_status -> wa.order "Получение статуса событий"

            wa.order -> kafka.payments "Создание событий оплаты"
            kafka.payments -> wa.billing "Обработка событий"
            wa.stock ->  kafka.payments_status "Отправка статуса событий"
            kafka.payments_status -> wa.order "Получение статуса событий"

            wa.order -> kafka.cour_reserve "Создание событий резерва курьеров"
            kafka.cour_reserve -> wa.delivery "Обработка событий"
            wa.delivery ->  kafka.cour_reserve_status "Отправка статуса событий"
            kafka.cour_reserve_status -> wa.order "Получение статуса событий"

            wa.order -> kafka.notifications "Создание событий уведомлений"
            kafka.notifications -> wa.notifications "Обработка событий"
        }
        
        payGate = softwareSystem "Платежный шлюз"
        
        geoService = softwareSystem "Сервис навигации"
        
        customer -> app.wa.auth "[POST] /register", "REST/HTTP"

        customer -> app.wa.stock "[GET] /get_items Получение ассортимента товаров", "REST/HTTP"
        
        customer -> app.wa.order "[POST] /create_order Делает заказ", "REST/HTTP"
        
        app.wa -> app.pg "Запись и чтение"
        
        app.wa.billing -> payGate "Запрос списания денег", "REST/HTTP"
        payGate -> app.wa.billing "Подтверждение или отмена списания", "REST/HTTP"

        app.wa.order -> geoService "Расчет времени доставки", "REST/HTTP"
    }

    views {
        systemContext app "Diagram1" {
            include *
            autolayout lr
        }

        container app "Diagram2" {
            include *
            autolayout lr
        }
        
        component app.wa "Diagram3" {
            include *
            autolayout tb
        }

        styles {
            element "Element" {
                color white
            }
            element "Component" {
                background blue
                color white
            }
            element "Person" {
                background #116611
                shape person
            }
            element "Software System" {
                background #2D882D
            }
            element "Container" {
                background #55aa55
            }
            element "Database" {
                shape cylinder
            }
        }
    }
}