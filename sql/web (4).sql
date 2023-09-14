-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Εξυπηρετητής: 127.0.0.1
-- Χρόνος δημιουργίας: 14 Σεπ 2023 στις 13:53:00
-- Έκδοση διακομιστή: 10.4.27-MariaDB
-- Έκδοση PHP: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Βάση δεδομένων: `web`
--

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `admin`
--

CREATE TABLE `admin` (
  `admin_id` smallint(6) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `category`
--

INSERT INTO `category` (`id`, `name`) VALUES
(1, 'Βρεφικά Είδη'),
(2, 'Καθαριότητα'),
(3, 'Ποτά - Αναψυκτικά'),
(4, 'Προσωπική φροντίδα');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `offers`
--

CREATE TABLE `offers` (
  `id` int(11) NOT NULL,
  `price` float NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `product_id` int(11) NOT NULL,
  `store_id` int(15) NOT NULL,
  `stock` enum('ΝΑΙ','ΟΧΙ') NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `offers`
--

INSERT INTO `offers` (`id`, `price`, `user_id`, `product_id`, `store_id`, `stock`, `date`) VALUES
(1, 1, 21, 59, 61, 'ΝΑΙ', '0000-00-00'),
(3, 4.8, 21, 194, 111, 'ΟΧΙ', '2023-08-11'),
(46, 2, 21, 59, 99, 'ΝΑΙ', '2023-08-24'),
(54, 1, 30, 472, 111, 'ΟΧΙ', '2023-08-24'),
(64, 5, 21, 1020, 99, 'ΝΑΙ', '2023-09-06'),
(66, 11, 21, 68, 99, 'ΝΑΙ', '2023-09-07'),
(67, 4, 34, 458, 111, 'ΝΑΙ', '2023-09-13'),
(71, 2, 35, 995, 89, 'ΝΑΙ', '2023-09-13');

--
-- Δείκτες `offers`
--
DELIMITER $$
CREATE TRIGGER `check_price` AFTER INSERT ON `offers` FOR EACH ROW BEGIN
    DECLARE new_price DECIMAL(10, 2);
    DECLARE ld_price DECIMAL(10, 2);
    DECLARE lw_price DECIMAL(10, 2);

    SET new_price = NEW.price;
	
    SELECT AVG(price) INTO lw_price
    FROM price
    WHERE product_id = NEW.product_id;
	
    SELECT price INTO ld_price
    FROM price
    WHERE product_id = NEW.product_id AND date = '2023-08-10';

    IF new_price < (ld_price * 0.8) THEN
            UPDATE user SET score = score + 50
            WHERE user_id = new.user_id ;
            
    ELSEIF new_price < (lw_price * 0.8) THEN
            UPDATE user SET score = score + 20
            WHERE user_id = new.user_id ;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `price`
--

CREATE TABLE `price` (
  `product_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `price`
--

INSERT INTO `price` (`product_id`, `date`, `price`) VALUES
(59, '2023-08-06', 1.04),
(59, '2023-08-07', 1.01),
(59, '2023-08-08', 1.02),
(59, '2023-08-09', 1),
(59, '2023-08-10', 0.99),
(68, '0000-00-00', 1.93),
(68, '2023-08-06', 2.03),
(68, '2023-08-07', 1.95),
(68, '2023-08-09', 1.94),
(68, '2023-08-10', 1.85),
(194, '2022-08-07', 8.53),
(194, '2023-08-06', 8.22),
(194, '2023-08-08', 8.5),
(194, '2023-08-09', 8.28),
(194, '2023-08-10', 8.31),
(234, '2023-08-06', 2.08),
(234, '2023-08-07', 1.91),
(234, '2023-08-08', 2.12),
(234, '2023-08-09', 2.11),
(234, '2023-08-10', 2.11),
(387, '2022-08-07', 2.5),
(387, '2023-08-06', 2.33),
(387, '2023-08-08', 2.8),
(387, '2023-08-09', 2.77),
(387, '2023-08-10', 4.02),
(458, '2022-08-07', 1.23),
(458, '2023-08-06', 1.12),
(458, '2023-08-08', 1.39),
(458, '2023-08-09', 1.33),
(458, '2023-08-10', 1.3),
(472, '2022-08-07', 1.39),
(472, '2023-08-06', 1.35),
(472, '2023-08-08', 1.4),
(472, '2023-08-09', 1.49),
(472, '2023-08-10', 1.7),
(669, '2022-08-07', 6.2),
(669, '2023-08-06', 5.9),
(669, '2023-08-08', 6.35),
(669, '2023-08-09', 6.22),
(669, '2023-08-10', 6.31),
(755, '2022-08-07', 3.9),
(755, '2023-08-06', 3.92),
(755, '2023-08-08', 3.75),
(755, '2023-08-09', 3.8),
(755, '2023-08-10', 3.82),
(814, '2022-08-07', 4.97),
(814, '2023-08-06', 4.9),
(814, '2023-08-08', 5.08),
(814, '2023-08-09', 5.2),
(814, '2023-08-10', 5.7),
(885, '2022-08-07', 2.59),
(885, '2023-08-06', 2.33),
(885, '2023-08-08', 2.62),
(885, '2023-08-09', 3.01),
(885, '2023-08-10', 2.6),
(995, '2022-08-07', 2.5),
(995, '2023-08-06', 2.33),
(995, '2023-08-08', 2.8),
(995, '2023-08-09', 2.77),
(995, '2023-08-10', 3.01),
(1020, '2022-08-07', 10.2),
(1020, '2023-08-06', 10.05),
(1020, '2023-08-08', 10.24),
(1020, '2023-08-09', 10.31),
(1020, '2023-08-10', 10.28);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `subcategory_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `product`
--

INSERT INTO `product` (`id`, `name`, `category_id`, `subcategory_id`) VALUES
(59, 'Pampers Πάνες Μωρού Premium Pants Nο 4 9-15κιλ 38τεμ', 1, 1),
(61, 'Moscato DΑsti Casarito Κρασί 750ml', 3, 6),
(68, 'Pampers Πάνες Premium Care Nο 3 5-9 κιλ 20τεμ', 1, 1),
(194, 'Heineken Μπύρα 6X330ml', 3, 5),
(234, 'Nan Optipro 4 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 400γρ', 1, 2),
(387, 'Noxzema Αποσμ Rollon Classic 50ml', 4, 7),
(458, 'Μέγα Βαμβάκι 100γρ', 4, 8),
(472, 'Amstel Μπύρα Premium Quality 0,5λιτ', 3, 5),
(669, 'Amstel Μπύρα 6Χ330ml', 3, 5),
(755, 'Septona Σαμπουάν Και Αφρόλουτρο Βρεφικό Με Αλοη 500ml', 1, 2),
(814, 'Axe Αποσμ Σπρέυ Dark Temptation 150ml', 4, 7),
(885, 'Dove Αποσμ Σπρέυ 150ml', 4, 7),
(995, 'Κρασί Της Παρέας Λευκό 1λιτ', 3, 6),
(1020, 'Γιώτης Sanilac 2 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 400γρ', 1, 2);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `react` tinyint(1) DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `ratings`
--

INSERT INTO `ratings` (`id`, `user_id`, `offer_id`, `react`, `timestamp`) VALUES
(37, 21, 67, 2, '2023-09-14 11:27:23');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `score_history`
--

CREATE TABLE `score_history` (
  `id` int(11) NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `added_score` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `score_history`
--

INSERT INTO `score_history` (`id`, `user_id`, `added_score`, `timestamp`) VALUES
(1, 30, 50, '2023-07-19 14:27:14'),
(2, 21, 50, '2023-09-06 17:46:13'),
(3, 21, 50, '2023-09-13 16:50:04'),
(4, 21, 50, '2023-09-13 16:50:04'),
(5, 35, 50, '2023-09-13 18:48:18');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `store`
--

CREATE TABLE `store` (
  `id` int(15) NOT NULL,
  `name` varchar(45) NOT NULL,
  `brand` varchar(50) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `store`
--

INSERT INTO `store` (`id`, `name`, `brand`, `latitude`, `longitude`) VALUES
(58, 'Lidl', 'Lidl', 38.2080319, 21.712654),
(59, 'The Mart', '', 38.28931, 21.7806567),
(60, 'Lidl', 'Lidl', 38.2633511, 21.7434265),
(61, 'Σουπερμάρκετ Ανδρικόπουλος', '', 38.2952086, 21.7908028),
(62, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2104365, 21.7642075),
(63, 'Papakos', '', 38.23553, 21.7622778),
(64, 'Lidl', 'Lidl', 38.2312926, 21.740082),
(65, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.3013087, 21.7814957),
(66, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2596476, 21.7489662),
(67, 'Ρουμελιώτης SUPER Market', '', 38.2613806, 21.7436127),
(68, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2585236, 21.741582),
(69, 'My market', '', 38.2323892, 21.7473265),
(70, 'ΑΒ Βασιλόπουλος', 'ΑΒ Βασιλόπουλος', 38.2322376, 21.7257294),
(71, 'Markoulas', '', 38.2644973, 21.7603629),
(72, 'Lidl', 'Lidl', 38.3067563, 21.8051332),
(73, 'Ανδρικόπουλος', '', 38.2399863, 21.736371),
(74, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2364945, 21.7373409),
(75, 'My Market', '', 38.2427052, 21.7342362),
(76, 'My market', '', 38.2568618, 21.7396708),
(77, 'Ανδρικόπουλος', '', 38.1951968, 21.7323293),
(78, 'ΑΒ ΒΑΣΙΛΟΠΟΥΛΟΣ', '', 38.2565589, 21.7418506),
(79, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2434859, 21.733285),
(80, 'Ανδρικόπουλος', '', 38.2427963, 21.7302559),
(81, 'Mini Market', '', 38.2725804, 21.8364993),
(82, 'Carna', '', 38.2795377, 21.7667136),
(83, 'Mini Market', '', 38.3052409, 21.7770011),
(84, 'Kronos', '', 38.2425794, 21.7296435),
(85, 'Φίλιππας', '', 38.2585639, 21.7504681),
(86, 'No supermarket', '', 38.2498065, 21.7363349),
(87, 'Kiosk', '', 38.2490852, 21.735128),
(88, 'Kiosk', '', 38.2493169, 21.7349115),
(89, 'Kiosk', '', 38.2489563, 21.7344427),
(90, 'Kiosk', '', 38.2569875, 21.7413066),
(91, 'Kiosk', '', 38.2561434, 21.7409531),
(92, 'Ανδρικόπουλος - Supermarket', '', 38.2691937, 21.7481501),
(93, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2690963, 21.7497014),
(94, 'Mini Market', '', 38.3277388, 21.8764222),
(95, 'ΑΒ Βασιλόπουλος', 'ΑΒ Βασιλόπουλος', 38.2170935, 21.7357783),
(96, 'Mini Market', '', 38.2160259, 21.7321204),
(97, '3A', '', 38.2504514, 21.7396687),
(98, 'Spar', 'Spar', 38.2486316, 21.7389771),
(99, 'ΑΝΔΡΙΚΟΠΟΥΛΟΣ', '', 38.2481545, 21.7383224),
(100, 'ΑΝΔΡΙΚΟΠΟΥΛΟΣ', '', 38.2429466, 21.7308044),
(101, 'MyMarket', '', 38.2392836, 21.7265283),
(102, 'Ena Cash And Carry', '', 38.2346622, 21.7253472),
(103, 'ΚΡΟΝΟΣ - (Σκαγιοπουλείου)', '', 38.2358002, 21.7294915),
(104, 'Ανδρικόπουλος Super Market', '', 38.2379176, 21.7306406),
(105, '3Α Αράπης', '', 38.2375068, 21.7328984),
(106, 'Γαλαξίας', 'Γαλαξίας', 38.2361127, 21.733787),
(107, 'Super Market Θεοδωρόπουλος', '', 38.2360129, 21.7283123),
(108, 'Super Market ΚΡΟΝΟΣ', '', 38.2390442, 21.7340723),
(109, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2601801, 21.7428703),
(110, '3A ARAPIS', '', 38.2586424, 21.7460078),
(111, 'Μασούτης', 'Μασούτης', 38.2454669, 21.7355058),
(112, 'ΑΒ Shop & Go', '', 38.24957, 21.7380288),
(113, '3Α ΑΡΑΠΗΣ', '', 38.2398789, 21.7455558),
(114, 'Περίπτερο', '', 38.2554443, 21.7408745);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `subcategory`
--

CREATE TABLE `subcategory` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `subcategory`
--

INSERT INTO `subcategory` (`id`, `name`, `category_id`) VALUES
(1, 'Πάνες', 1),
(2, 'Γάλα', 1),
(3, 'Χαρτικά', 2),
(4, 'Αποσμητικά Χώρου', 2),
(5, 'Μπύρες', 3),
(6, 'Κρασιά', 3),
(7, 'Αποσμητικά', 4),
(8, 'Βαμβάκια', 4);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `token_history`
--

CREATE TABLE `token_history` (
  `id` int(11) NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `added_tokens` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `token_history`
--

INSERT INTO `token_history` (`id`, `user_id`, `added_tokens`, `timestamp`) VALUES
(2, 21, 320, '2023-09-12 14:58:56');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `user`
--

CREATE TABLE `user` (
  `user_id` smallint(6) NOT NULL,
  `username` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(42) DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `score` int(11) NOT NULL DEFAULT 0,
  `tokens` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `user`
--

INSERT INTO `user` (`user_id`, `username`, `email`, `password`, `is_admin`, `score`, `tokens`) VALUES
(21, 'Panagiotis', 'leospanagiotis@gmail.com', '*84CC92B25B13F4CEA01DF913B6215B83438B2921', 0, 215, 320),
(30, 'admin', 'admin@test.gr', '*B3D0CD604CE2C2112084799DEF9DF796B789AEA1', 1, 100, 0),
(31, 'vaslis', 'leosvasilis@gmail.com', '*51B8DF371278FD677D923013F0759878ECED408D', 0, 0, 0),
(32, 'apostolos', 'apostolos.xri@gmail.com', '*9AAD199314F5D8362CAA482C2D781424B73076CC', 0, 0, 0),
(34, 'info', 'info@test.gr', '*84CC92B25B13F4CEA01DF913B6215B83438B2921', 0, 0, 0),
(35, 'nikolaras', 'nikolaspi2001@gmail.com', '*6484C87EF7BC12271771128D1B23043244EE1F36', 0, 50, 0);

--
-- Δείκτες `user`
--
DELIMITER $$
CREATE TRIGGER `score_history` AFTER UPDATE ON `user` FOR EACH ROW BEGIN
    IF NEW.score != OLD.score THEN
        INSERT INTO score_history (user_id, added_score,timestamp)
        VALUES (NEW.user_id, NEW.score - OLD.score, NOW());
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `token_history` AFTER UPDATE ON `user` FOR EACH ROW BEGIN
    IF NEW.tokens != OLD.tokens THEN
        INSERT INTO token_history (user_id, added_tokens,timestamp)
        VALUES (NEW.user_id, NEW.tokens - OLD.tokens,NOW());
    END IF;
END
$$
DELIMITER ;

--
-- Ευρετήρια για άχρηστους πίνακες
--

--
-- Ευρετήρια για πίνακα `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Ευρετήρια για πίνακα `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `store_id` (`store_id`,`product_id`),
  ADD KEY `product_id_fk` (`product_id`),
  ADD KEY `user_id_fk` (`user_id`);

--
-- Ευρετήρια για πίνακα `price`
--
ALTER TABLE `price`
  ADD UNIQUE KEY `unique_product_date` (`product_id`,`date`);

--
-- Ευρετήρια για πίνακα `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subcategory_id_fk` (`subcategory_id`),
  ADD KEY `category_id_fk1` (`category_id`);

--
-- Ευρετήρια για πίνακα `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_fk1` (`user_id`),
  ADD KEY `offer_id_fk` (`offer_id`);

--
-- Ευρετήρια για πίνακα `score_history`
--
ALTER TABLE `score_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_fk2` (`user_id`);

--
-- Ευρετήρια για πίνακα `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `subcategory`
--
ALTER TABLE `subcategory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id_fk` (`category_id`);

--
-- Ευρετήρια για πίνακα `token_history`
--
ALTER TABLE `token_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_fk3` (`user_id`);

--
-- Ευρετήρια για πίνακα `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email_index` (`email`),
  ADD UNIQUE KEY `username_index` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT για άχρηστους πίνακες
--

--
-- AUTO_INCREMENT για πίνακα `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `offers`
--
ALTER TABLE `offers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT για πίνακα `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT για πίνακα `score_history`
--
ALTER TABLE `score_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT για πίνακα `store`
--
ALTER TABLE `store`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT για πίνακα `token_history`
--
ALTER TABLE `token_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT για πίνακα `user`
--
ALTER TABLE `user`
  MODIFY `user_id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `offers`
--
ALTER TABLE `offers`
  ADD CONSTRAINT `product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `store_id_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`),
  ADD CONSTRAINT `user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `price`
--
ALTER TABLE `price`
  ADD CONSTRAINT `product_id_fk1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `category_id_fk1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  ADD CONSTRAINT `subcategory_id_fk` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `offer_id_fk` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`),
  ADD CONSTRAINT `user_id_fk1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Περιορισμοί για πίνακα `score_history`
--
ALTER TABLE `score_history`
  ADD CONSTRAINT `user_id_fk2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Περιορισμοί για πίνακα `subcategory`
--
ALTER TABLE `subcategory`
  ADD CONSTRAINT `category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `token_history`
--
ALTER TABLE `token_history`
  ADD CONSTRAINT `user_id_fk3` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
