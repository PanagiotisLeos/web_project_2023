-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Εξυπηρετητής: 127.0.0.1
-- Χρόνος δημιουργίας: 20 Σεπ 2023 στις 16:15:28
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

DELIMITER $$
--
-- Συναρτήσεις
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CheckPriceAndRenewOffer` (`offer_id` INT) RETURNS TINYINT(1)  BEGIN
    DECLARE price DECIMAL(10, 2);
    DECLARE ld_price DECIMAL(10, 2);
    DECLARE lw_price DECIMAL(10, 2);
    DECLARE crt tinyint ;
	
    SELECT offers.price into price FROM offers where offers.id = offer_id;
	
    SELECT AVG(price.price) INTO lw_price
    FROM offers
    INNER JOIN product on offers.product_id = product.id
    INNER JOIN price on price.product_id = product.id
    WHERE offers.id = offer_id;
    
    SELECT price.price INTO ld_price
    FROM offers
    INNER JOIN product on offers.product_id = product.id
    INNER JOIN price on price.product_id = product.id
    WHERE offers.id = offer_id AND offers.date = '2023-08-10';

    IF price < (ld_price * 0.8) THEN
    	set crt = 1;
        END IF;

            
    IF price < (lw_price * 0.8) THEN
              	set crt = 2;
                 END IF;
   
	IF price < (ld_price * 0.8) AND price < (lw_price * 0.8) THEN
    set crt = 3;
                
    END IF;
    
    RETURN crt;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `check_price` (`product_id1` INT, `price1` INT) RETURNS TINYINT(1)  BEGIN
    DECLARE new_price DECIMAL(10, 2);
    DECLARE ld_price DECIMAL(10, 2);
    DECLARE lw_price DECIMAL(10, 2);
    DECLARE crt tinyint ;

    SET new_price = price1;
	
    SELECT AVG(price) INTO lw_price
    FROM price
    WHERE product_id = product_id1
    GROUP by product_id;
	
    SELECT price INTO ld_price
    FROM price
    WHERE product_id = product_id1 AND date = '2023-08-10';

        
 IF new_price < (ld_price * 0.8) AND new_price < (lw_price * 0.8) THEN
    set crt = 3;
    end if ;
    IF new_price < (ld_price * 0.8) THEN
    	set crt = 1;
       end IF;     
    IF new_price < (lw_price * 0.8) THEN
        set crt = 2;
    END IF;
    
    RETURN crt;
END$$

DELIMITER ;

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
  `date` date NOT NULL,
  `a5ai` bit(1) NOT NULL,
  `a5aii` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Δείκτες `offers`
--
DELIMITER $$
CREATE TRIGGER `OfferCreated` AFTER INSERT ON `offers` FOR EACH ROW BEGIN
    INSERT INTO offers_history (offer_id, price, user_id, product_id, store_id, date, action, action_date)
    VALUES (NEW.id, NEW.price, NEW.user_id, NEW.product_id, NEW.store_id, NEW.date, 'created', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OfferDeleted` BEFORE DELETE ON `offers` FOR EACH ROW BEGIN
    INSERT INTO offers_history (offer_id, price, user_id, product_id, store_id, date, action, action_date)
    VALUES (OLD.id, OLD.price, OLD.user_id, OLD.product_id, OLD.store_id, OLD.date, 'deleted', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OfferRenewd` AFTER UPDATE ON `offers` FOR EACH ROW BEGIN
    INSERT INTO offers_history (offer_id, price, user_id, product_id, store_id, date, action, action_date)
    VALUES (NEW.id, NEW.price, NEW.user_id, NEW.product_id, NEW.store_id, NEW.date, 'renewd', NOW());
END
$$
DELIMITER ;
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
DELIMITER $$
CREATE TRIGGER `price_criteria` BEFORE INSERT ON `offers` FOR EACH ROW BEGIN 

IF check_price(new.product_id,new.price) = 3 THEN
	set new.a5ai = 1;
    set new.a5aii = 1;
  
ELSEIF check_price(new.product_id,new.price) = 1 THEN
	set new.a5ai = 1;
    
ELSEIF check_price(new.product_id,new.price) = 2 THEN
	set new.a5aii = 1;   
end IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `offers_history`
--

CREATE TABLE `offers_history` (
  `offer_id` int(11) NOT NULL,
  `price` float NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `product_id` int(11) NOT NULL,
  `store_id` int(15) NOT NULL,
  `date` date NOT NULL,
  `action` enum('created','renewd','deleted') CHARACTER SET armscii8 COLLATE armscii8_bin NOT NULL,
  `action_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Άδειασμα δεδομένων του πίνακα `offers_history`
--

INSERT INTO `offers_history` (`offer_id`, `price`, `user_id`, `product_id`, `store_id`, `date`, `action`, `action_date`) VALUES
(78, 6, 21, 458, 156, '2023-09-10', 'created', '2023-09-19 15:09:31'),
(78, 6, 21, 458, 156, '2023-09-10', 'renewd', '2023-09-19 15:15:13'),
(78, 30, 21, 458, 156, '2023-09-10', 'renewd', '2023-09-19 15:15:32'),
(79, 1, 21, 885, 156, '2023-09-19', 'created', '2023-09-19 15:28:05'),
(80, 1, 21, 885, 168, '2023-09-19', 'created', '2023-09-19 15:28:05'),
(81, 1, 21, 234, 156, '2023-09-19', 'created', '2023-09-19 15:32:11'),
(82, 1, 21, 234, 168, '2023-09-19', 'created', '2023-09-19 15:32:11'),
(83, 1, 21, 234, 155, '2023-09-19', 'created', '2023-09-19 15:32:11'),
(84, 2, 21, 59, 155, '2023-09-19', 'created', '2023-09-19 15:36:29'),
(73, 5, 21, 194, 168, '2023-09-14', 'deleted', '2023-09-19 15:38:05'),
(74, 15, 21, 68, 168, '2023-09-15', 'deleted', '2023-09-19 15:38:05'),
(75, 4, 30, 995, 168, '2023-09-15', 'deleted', '2023-09-19 15:38:05'),
(76, 7, 30, 995, 156, '2023-09-15', 'deleted', '2023-09-19 15:38:05'),
(77, 15, 30, 755, 156, '2023-09-15', 'deleted', '2023-09-19 15:38:05'),
(78, 30, 21, 458, 156, '2023-09-10', 'deleted', '2023-09-19 15:38:05'),
(79, 1, 21, 885, 156, '2023-09-19', 'deleted', '2023-09-19 15:38:05'),
(80, 1, 21, 885, 168, '2023-09-19', 'deleted', '2023-09-19 15:38:05'),
(81, 1, 21, 234, 156, '2023-09-19', 'deleted', '2023-09-19 15:38:05'),
(82, 1, 21, 234, 168, '2023-09-19', 'deleted', '2023-09-19 15:38:05'),
(83, 1, 21, 234, 155, '2023-09-19', 'deleted', '2023-09-19 15:38:05'),
(84, 2, 21, 59, 155, '2023-09-19', 'deleted', '2023-09-19 15:38:05'),
(85, 1, 21, 387, 168, '2023-09-19', 'created', '2023-09-19 15:38:26'),
(86, 7, 21, 194, 168, '2023-09-19', 'created', '2023-09-19 15:44:44'),
(87, 7, 21, 194, 136, '2023-09-19', 'created', '2023-09-19 15:44:44'),
(88, 5, 21, 995, 168, '2023-09-19', 'created', '2023-09-19 15:48:13'),
(89, 5, 21, 995, 136, '2023-09-19', 'created', '2023-09-19 15:48:13'),
(91, 15, 21, 387, 136, '2023-09-19', 'created', '2023-09-19 15:49:25'),
(91, 15, 21, 387, 136, '2023-09-10', 'renewd', '2023-09-19 15:56:22'),
(91, 15, 21, 387, 136, '2023-09-10', 'deleted', '2023-09-19 16:00:27'),
(89, 5, 21, 995, 136, '2023-09-10', 'renewd', '2023-09-19 16:08:57'),
(89, 1, 21, 995, 136, '2023-09-10', 'renewd', '2023-09-19 16:09:01'),
(87, 7, 21, 194, 136, '2023-09-19', 'deleted', '2023-09-20 08:48:53'),
(88, 5, 21, 995, 168, '2023-09-19', 'deleted', '2023-09-20 08:49:28'),
(86, 7, 21, 194, 168, '2023-09-19', 'deleted', '2023-09-20 08:49:41'),
(92, 15, 30, 59, 136, '2023-09-20', 'created', '2023-09-20 09:04:45'),
(92, 15, 30, 59, 136, '2023-09-20', 'deleted', '2023-09-20 09:04:57'),
(89, 1, 21, 995, 136, '2023-09-20', 'renewd', '2023-09-20 09:22:21'),
(85, 1, 21, 387, 168, '2023-09-19', 'deleted', '2023-09-20 09:22:45'),
(98, 1, 21, 194, 136, '2023-09-20', 'created', '2023-09-20 10:25:24'),
(100, 1, 21, 59, 136, '2023-09-20', 'created', '2023-09-20 10:26:44'),
(101, 1, 21, 472, 136, '2023-09-20', 'created', '2023-09-20 10:30:45'),
(103, 1, 21, 1020, 136, '2023-09-20', 'created', '2023-09-20 10:33:53'),
(110, 1, 21, 387, 136, '2023-09-20', 'created', '2023-09-20 10:35:56'),
(114, 1, 21, 387, 168, '2023-09-20', 'created', '2023-09-20 10:42:35'),
(89, 1, 21, 995, 136, '2023-09-20', 'deleted', '2023-09-20 11:25:19'),
(98, 1, 21, 194, 136, '2023-09-20', 'deleted', '2023-09-20 11:25:19'),
(100, 1, 21, 59, 136, '2023-09-20', 'deleted', '2023-09-20 11:25:19'),
(101, 1, 21, 472, 136, '2023-09-20', 'deleted', '2023-09-20 11:25:19'),
(103, 1, 21, 1020, 136, '2023-09-20', 'deleted', '2023-09-20 11:25:19'),
(110, 1, 21, 387, 136, '2023-09-20', 'deleted', '2023-09-20 11:25:19'),
(114, 1, 21, 387, 168, '2023-09-20', 'deleted', '2023-09-20 11:25:19'),
(117, 1, 21, 59, 168, '2023-09-20', 'created', '2023-09-20 11:26:27'),
(125, 1, 21, 669, 168, '2023-09-20', 'created', '2023-09-20 11:32:21'),
(127, 1, 21, 61, 168, '2023-09-20', 'created', '2023-09-20 11:53:03'),
(128, 1, 21, 1020, 168, '2023-09-20', 'created', '2023-09-20 11:53:59'),
(129, 1, 21, 458, 168, '2023-09-20', 'created', '2023-09-20 11:55:33'),
(117, 1, 21, 59, 168, '2023-09-20', 'deleted', '2023-09-20 12:07:14'),
(125, 1, 21, 669, 168, '2023-09-20', 'deleted', '2023-09-20 12:07:14'),
(127, 1, 21, 61, 168, '2023-09-20', 'deleted', '2023-09-20 12:07:14'),
(128, 1, 21, 1020, 168, '2023-09-20', 'deleted', '2023-09-20 12:07:14'),
(129, 1, 21, 458, 168, '2023-09-20', 'deleted', '2023-09-20 12:07:14'),
(131, 2, 21, 995, 168, '2023-09-20', 'created', '2023-09-20 12:07:33'),
(131, 2, 21, 995, 168, '2023-09-10', 'renewd', '2023-09-20 12:14:15'),
(131, 2, 21, 995, 168, '2023-09-20', 'renewd', '2023-09-20 12:14:21'),
(131, 2, 21, 995, 168, '2023-09-20', 'renewd', '2023-09-20 12:16:06'),
(131, 2, 21, 995, 168, '2023-09-20', 'renewd', '2023-09-20 12:16:15'),
(132, 10, 21, 387, 168, '2023-09-20', 'created', '2023-09-20 12:18:31'),
(133, 10, 21, 387, 156, '2023-09-20', 'created', '2023-09-20 12:18:31'),
(139, 2, 21, 669, 156, '2023-09-20', 'created', '2023-09-20 12:25:57'),
(141, 5, 21, 68, 156, '2023-09-20', 'created', '2023-09-20 12:26:28'),
(132, 10, 21, 387, 168, '2023-09-20', 'deleted', '2023-09-20 12:35:13'),
(141, 5, 21, 68, 156, '2023-09-20', 'deleted', '2023-09-20 12:35:24'),
(133, 10, 21, 387, 156, '2023-09-20', 'deleted', '2023-09-20 12:35:34'),
(131, 2, 21, 995, 168, '2023-09-20', 'deleted', '2023-09-20 12:37:30'),
(142, 4, 30, 458, 156, '2023-09-20', 'created', '2023-09-20 12:37:46'),
(139, 2, 21, 669, 156, '2023-09-20', 'deleted', '2023-09-20 12:37:51');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `price`
--

CREATE TABLE `price` (
  `product_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

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
-- Δείκτες `ratings`
--
DELIMITER $$
CREATE TRIGGER `rate_score` AFTER INSERT ON `ratings` FOR EACH ROW BEGIN
DECLARE rated_user INT;

  SELECT user_id into rated_user from offers where offers.id = new.offer_id;
  IF new.react = 2 THEN
        UPDATE user SET score = score + 5 WHERE user.user_id = rated_user;
	ELSEIF new.react = 1 THEN
    	UPDATE user SET score = score - 1 WHERE user.user_id = rated_user;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `rate_score_delete` AFTER DELETE ON `ratings` FOR EACH ROW BEGIN
DECLARE rated_user INT;

  SELECT user_id into rated_user from offers where offers.id = old.offer_id;
  
  	IF old.react = 2 THEN
        UPDATE user SET score = score - 5 WHERE user.user_id = rated_user;
        
	ELSEIF old.react = 1 THEN
    	UPDATE user SET score = score + 1 WHERE user.user_id = rated_user;
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `rate_score_update` AFTER UPDATE ON `ratings` FOR EACH ROW BEGIN
DECLARE rated_user INT;

  SELECT user_id into rated_user from offers where offers.id = new.offer_id;
  
  	IF new.react = 0 and old.react = 1 THEN
        UPDATE user SET score = score - 5 WHERE user.user_id = rated_user;
        
	ELSEIF new.react = 0 and old.react = 2 THEN
    	UPDATE user SET score = score + 1 WHERE user.user_id = rated_user;

	ELSEIF new.react = 2 and old.react = 1 THEN 
    	UPDATE user SET score = score + 6 WHERE user.user_id = rated_user;
    
    ELSEIF new.react = 1 and old.react = 2 THEN 
    	UPDATE user SET score = score - 6 WHERE user.user_id = rated_user;
    
    
    END IF;
END
$$
DELIMITER ;

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
(5, 35, 50, '2023-09-13 18:48:18'),
(6, 21, 50, '2023-09-14 14:43:48'),
(7, 21, 5, '2023-09-14 15:15:45'),
(8, 21, 5, '2023-09-14 16:04:46'),
(9, 21, -5, '2023-09-14 16:04:54'),
(10, 21, -1, '2023-09-14 16:04:58'),
(11, 21, 6, '2023-09-14 16:05:02'),
(12, 21, -5, '2023-09-14 16:05:20'),
(13, 21, -1, '2023-09-14 16:05:26'),
(14, 21, 6, '2023-09-14 16:05:31'),
(15, 21, -5, '2023-09-14 16:05:39'),
(16, 21, 5, '2023-09-14 16:44:23'),
(17, 21, -5, '2023-09-14 16:44:24'),
(18, 21, 5, '2023-09-15 08:15:01'),
(19, 21, -6, '2023-09-15 08:25:12'),
(20, 21, 6, '2023-09-15 08:25:14'),
(21, 21, -6, '2023-09-15 10:02:27'),
(22, 21, 6, '2023-09-15 10:06:57'),
(23, 21, -1, '2023-09-15 10:08:48'),
(24, 21, -5, '2023-09-19 13:03:26'),
(25, 21, 5, '2023-09-19 13:03:27'),
(26, 21, 50, '2023-09-19 15:28:05'),
(27, 21, 50, '2023-09-19 15:28:05'),
(28, 21, 50, '2023-09-19 15:32:11'),
(29, 21, 50, '2023-09-19 15:32:11'),
(30, 21, 50, '2023-09-19 15:32:11'),
(31, 21, 50, '2023-09-19 15:38:26'),
(32, 21, 5, '2023-09-19 16:33:13'),
(38, 21, 50, '2023-09-20 10:25:24'),
(39, 21, 50, '2023-09-20 10:30:45'),
(40, 21, 50, '2023-09-20 10:33:53'),
(41, 21, 50, '2023-09-20 10:35:56'),
(42, 21, 50, '2023-09-20 10:42:35'),
(45, 21, 50, '2023-09-20 11:32:21'),
(46, 21, 50, '2023-09-20 11:53:59'),
(47, 21, 50, '2023-09-20 11:55:33'),
(48, 21, 50, '2023-09-20 12:07:33'),
(49, 21, 5, '2023-09-20 12:08:24'),
(50, 21, 50, '2023-09-20 12:25:57');

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
(115, 'Lidl', 'Lidl', 38.2080319, 21.712654),
(116, 'The Mart', '', 38.28931, 21.7806567),
(117, 'Lidl', 'Lidl', 38.2633511, 21.7434265),
(118, 'Σουπερμάρκετ Ανδρικόπουλος', '', 38.2952086, 21.7908028),
(119, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2104365, 21.7642075),
(120, 'Papakos', '', 38.23553, 21.7622778),
(121, 'Lidl', 'Lidl', 38.2312926, 21.740082),
(122, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.3013087, 21.7814957),
(123, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2596476, 21.7489662),
(124, 'Ρουμελιώτης SUPER Market', '', 38.2613806, 21.7436127),
(125, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2585236, 21.741582),
(126, 'My market', '', 38.2323892, 21.7473265),
(127, 'ΑΒ Βασιλόπουλος', 'ΑΒ Βασιλόπουλος', 38.2322376, 21.7257294),
(128, 'Markoulas', '', 38.2644973, 21.7603629),
(129, 'Lidl', 'Lidl', 38.3067563, 21.8051332),
(130, 'Ανδρικόπουλος', '', 38.2399863, 21.736371),
(131, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2364945, 21.7373409),
(132, 'My Market', '', 38.2427052, 21.7342362),
(133, 'My market', '', 38.2568618, 21.7396708),
(134, 'Ανδρικόπουλος', '', 38.1951968, 21.7323293),
(135, 'ΑΒ ΒΑΣΙΛΟΠΟΥΛΟΣ', '', 38.2565589, 21.7418506),
(136, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2434859, 21.733285),
(137, 'Ανδρικόπουλος', '', 38.2427963, 21.7302559),
(138, 'Mini Market', '', 38.2725804, 21.8364993),
(139, 'Carna', '', 38.2795377, 21.7667136),
(140, 'Mini Market', '', 38.3052409, 21.7770011),
(141, 'Kronos', '', 38.2425794, 21.7296435),
(142, 'Φίλιππας', '', 38.2585639, 21.7504681),
(143, 'No supermarket', '', 38.2498065, 21.7363349),
(144, 'Kiosk', '', 38.2490852, 21.735128),
(145, 'Kiosk', '', 38.2493169, 21.7349115),
(146, 'Kiosk', '', 38.2489563, 21.7344427),
(147, 'Kiosk', '', 38.2569875, 21.7413066),
(148, 'Kiosk', '', 38.2561434, 21.7409531),
(149, 'Ανδρικόπουλος - Supermarket', '', 38.2691937, 21.7481501),
(150, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2690963, 21.7497014),
(151, 'Mini Market', '', 38.3277388, 21.8764222),
(152, 'ΑΒ Βασιλόπουλος', 'ΑΒ Βασιλόπουλος', 38.2170935, 21.7357783),
(153, 'Mini Market', '', 38.2160259, 21.7321204),
(154, '3A', '', 38.2504514, 21.7396687),
(155, 'Spar', 'Spar', 38.2486316, 21.7389771),
(156, 'ΑΝΔΡΙΚΟΠΟΥΛΟΣ', '', 38.2481545, 21.7383224),
(157, 'ΑΝΔΡΙΚΟΠΟΥΛΟΣ', '', 38.2429466, 21.7308044),
(158, 'MyMarket', '', 38.2392836, 21.7265283),
(159, 'Ena Cash And Carry', '', 38.2346622, 21.7253472),
(160, 'ΚΡΟΝΟΣ - (Σκαγιοπουλείου)', '', 38.2358002, 21.7294915),
(161, 'Ανδρικόπουλος Super Market', '', 38.2379176, 21.7306406),
(162, '3Α Αράπης', '', 38.2375068, 21.7328984),
(163, 'Γαλαξίας', 'Γαλαξίας', 38.2361127, 21.733787),
(164, 'Super Market Θεοδωρόπουλος', '', 38.2360129, 21.7283123),
(165, 'Super Market ΚΡΟΝΟΣ', '', 38.2390442, 21.7340723),
(166, 'Σκλαβενίτης', 'Σκλαβενίτης', 38.2601801, 21.7428703),
(167, '3A ARAPIS', '', 38.2586424, 21.7460078),
(168, 'Μασούτης', 'Μασούτης', 38.2454669, 21.7355058),
(169, 'ΑΒ Shop & Go', '', 38.24957, 21.7380288),
(170, '3Α ΑΡΑΠΗΣ', '', 38.2398789, 21.7455558),
(171, 'Περίπτερο', '', 38.2554443, 21.7408745);

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
(2, 21, 320, '2023-09-12 14:58:56'),
(3, 21, 323, '2023-09-15 12:05:54'),
(4, 35, 77, '2023-09-15 12:05:54'),
(5, 21, 365, '2023-09-20 09:38:14'),
(6, 35, 35, '2023-09-20 09:38:14');

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
(21, 'Panagiotis', 'leospanagiotis@gmail.com', '*84CC92B25B13F4CEA01DF913B6215B83438B2921', 0, 1084, 1008),
(30, 'admin', 'admin@test.gr', '*B3D0CD604CE2C2112084799DEF9DF796B789AEA1', 1, 100, 0),
(31, 'vaslis', 'leosvasilis@gmail.com', '*51B8DF371278FD677D923013F0759878ECED408D', 0, 0, 0),
(32, 'apostolos', 'apostolos.xri@gmail.com', '*9AAD199314F5D8362CAA482C2D781424B73076CC', 0, 0, 0),
(34, 'info', 'info@test.gr', '*84CC92B25B13F4CEA01DF913B6215B83438B2921', 0, 0, 0),
(35, 'nikolaras', 'nikolaspi2001@gmail.com', '*6484C87EF7BC12271771128D1B23043244EE1F36', 0, 50, 112);

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
  ADD KEY `offer_id_fk` (`offer_id`),
  ADD KEY `user_id_fk1` (`user_id`);

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
-- AUTO_INCREMENT για πίνακα `offers`
--
ALTER TABLE `offers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=143;

--
-- AUTO_INCREMENT για πίνακα `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT για πίνακα `score_history`
--
ALTER TABLE `score_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT για πίνακα `store`
--
ALTER TABLE `store`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=172;

--
-- AUTO_INCREMENT για πίνακα `token_history`
--
ALTER TABLE `token_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  ADD CONSTRAINT `store_id_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
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
  ADD CONSTRAINT `category_id_fk1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `subcategory_id_fk` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `offer_id_fk` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_id_fk1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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

DELIMITER $$
--
-- Συμβάντα
--
CREATE DEFINER=`root`@`localhost` EVENT `CheckAndRenewOfferstest` ON SCHEDULE EVERY 1 MINUTE STARTS '2023-09-20 12:21:21' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE offerIdToDelete INT;
    DECLARE cur CURSOR FOR SELECT id FROM offers WHERE DATE < NOW() - INTERVAL 7 DAY;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO offerIdToDelete;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF CheckPriceAndRenewOffer(offerIdToDelete) in (1,2) THEN
            UPDATE offers SET date = NOW() WHERE id = offerIdToDelete;
        ELSE
            DELETE FROM offers WHERE id = offerIdToDelete;
        END IF;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
