CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    avatar_url TEXT,
    role VARCHAR(20) NOT NULL DEFAULT 'customer', -- customer | admin
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(100) NOT NULL UNIQUE,
  icon_url    TEXT,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE products (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id     UUID REFERENCES categories(id),
  name            VARCHAR(255) NOT NULL,
  description     TEXT,
  price           DECIMAL(12,2) NOT NULL,
  compare_price   DECIMAL(12,2),          -- original / strikethrough price
  stock           INT NOT NULL DEFAULT 0,
  sku             VARCHAR(64),
  is_active       BOOLEAN DEFAULT true,
  avg_rating      DECIMAL(3,2) DEFAULT 0,
  review_count    INT DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE product_images (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  url         TEXT NOT NULL,
  sort_order  INT DEFAULT 0,
  is_primary  BOOLEAN DEFAULT false
);

CREATE TABLE addresses (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  label         VARCHAR(50) DEFAULT 'Home',  -- Home, Work, etc.
  full_name     VARCHAR(150) NOT NULL,
  phone         VARCHAR(30),
  street        VARCHAR(255) NOT NULL,
  city          VARCHAR(100) NOT NULL,
  state         VARCHAR(100),
  zip_code      VARCHAR(20),
  country       VARCHAR(100) DEFAULT 'United States',
  is_default    BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE cart_items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity    INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

CREATE TABLE wishlists (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

CREATE TABLE orders (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number      VARCHAR(20) UNIQUE NOT NULL,  -- e.g. A27685806
  user_id           UUID NOT NULL REFERENCES users(id),
  address_id        UUID REFERENCES addresses(id),
  status            VARCHAR(30) NOT NULL DEFAULT 'pending',
  -- pending | confirmed | processing | shipped | delivered | cancelled | on_hold
  subtotal          DECIMAL(12,2) NOT NULL,
  shipping_cost     DECIMAL(12,2) DEFAULT 0,
  tax               DECIMAL(12,2) DEFAULT 0,
  total             DECIMAL(12,2) NOT NULL,
  payment_method    VARCHAR(50),          -- link, card, etc.
  payment_status    VARCHAR(30) DEFAULT 'pending',
  payment_intent_id VARCHAR(255),
  notes             TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE order_items (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id      UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id    UUID REFERENCES products(id),
  product_name  VARCHAR(255) NOT NULL,   -- snapshot
  product_image TEXT,
  unit_price    DECIMAL(12,2) NOT NULL,
  quantity      INT NOT NULL,
  line_total    DECIMAL(12,2) NOT NULL
);

CREATE TABLE reviews (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id),
  product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  order_id    UUID REFERENCES orders(id),
  rating      SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment     TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id, order_id)
);

CREATE TABLE user_settings (
  user_id                  UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  push_notifications       BOOLEAN DEFAULT true,
  email_notifications      BOOLEAN DEFAULT true,
  order_updates            BOOLEAN DEFAULT true,
  promotional_emails       BOOLEAN DEFAULT false,
  two_factor_enabled      BOOLEAN DEFAULT false,
  biometric_login          BOOLEAN DEFAULT false,
  updated_at               TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_active ON products(is_active) WHERE is_active = true;
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_cart_user ON cart_items(user_id);
CREATE INDEX idx_wishlist_user ON wishlists(user_id);