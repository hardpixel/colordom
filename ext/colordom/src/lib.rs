use std::path::PathBuf;

use magnus::{
  function, method, prelude::*, value::Lazy, Ruby,
  Error, ExceptionClass, RModule, IntoValueFromNative
};

use image::{DynamicImage};
use palette_extract::{Quality, MaxColors, PixelEncoding, PixelFilter};
use palette::{FromColor, IntoColor, Lab, Pixel, Srgb};

static MODULE: Lazy<RModule> =
  Lazy::new(|ruby| ruby.class_object().const_get("Colordom").unwrap());

static ERROR: Lazy<ExceptionClass> =
  Lazy::new(|ruby| ruby.get_inner(&MODULE).const_get("Error").unwrap());

fn colordom_error() -> ExceptionClass {
  Ruby::get().unwrap().get_inner(&ERROR)
}

macro_rules! error {
  ($ex:ident) => {
    Error::new(colordom_error(), $ex.to_string())
  };
}

#[derive(Clone)]
#[magnus::wrap(class = "Colordom::Color", free_immediately, size)]
struct Color {
  r: u8,
  g: u8,
  b: u8
}

// This is safe as Color does not contain any Ruby types
// check issue https://github.com/matsadler/magnus/issues/66
unsafe impl IntoValueFromNative for Color {}

impl Color {
  fn new(r: u8, g: u8, b: u8) -> Self {
    Self { r, g, b }
  }

  fn r(&self) -> u8 { self.r }
  fn g(&self) -> u8 { self.g }
  fn b(&self) -> u8 { self.b }

  fn rgb(&self) -> Vec<u8> {
    vec![self.r, self.g, self.b]
  }

  fn hex(&self) -> String {
    format!("#{:02X}{:02X}{:02X}", self.r, self.g, self.b)
  }
}

#[derive(Clone)]
#[magnus::wrap(class = "Colordom::Image", free_immediately, size)]
struct Image {
  img: DynamicImage
}

impl Image {
  fn new(path: PathBuf) -> Result<Self, Error> {
    match image::open(&path) {
      Ok(img) => Ok(Self { img }),
      Err(ex) => Err(error!(ex))
    }
  }

  fn pixels(&self) -> &[u8] {
    self.img.as_bytes()
  }

  fn has_alpha(&self) -> bool {
    self.img.color().has_alpha()
  }

  fn histogram(&self, max_colors: usize) -> Vec<Color> {
    let colors = dominant_color::get_colors(
      &self.pixels(),
      self.has_alpha()
    );

    colors.chunks(3)
      .take(max_colors)
      .map(|x| Color::new(x[0], x[1], x[2]))
      .collect::<Vec<Color>>()
  }

  fn mediancut(&self, max_colors: usize) -> Vec<Color> {
    let colors = palette_extract::get_palette_with_options(
      &self.pixels(),
      PixelEncoding::Rgb,
      Quality::new(6),
      MaxColors::new(max_colors as u8),
      PixelFilter::None
    );

    colors.iter()
      .take(max_colors)
      .map(|x| Color::new(x.r, x.g, x.b))
      .collect::<Vec<Color>>()
  }

  fn kmeans(&self, max_colors: usize) -> Vec<Color> {
    let max_iterations = 20;
    let converge = 1.0;
    let verbose = false;
    let seed = 0;

    let lab: Vec<Lab> = Srgb::from_raw_slice(&self.pixels()).iter()
      .map(|x| x.into_format().into_color())
      .collect();

    let result = kmeans_colors::get_kmeans_hamerly(
      max_colors, max_iterations, converge, verbose, &lab, seed
    );

    let colors = &result.centroids.iter()
      .map(|x| Srgb::from_color(*x).into_format())
      .collect::<Vec<Srgb<u8>>>();

    colors.iter()
      .take(max_colors)
      .map(|x| Color::new(x.red, x.green, x.blue))
      .collect::<Vec<Color>>()
  }
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
  let module = ruby.define_module("Colordom")?;

  let colorc = module.define_class("Color", ruby.class_object())?;

  colorc.define_singleton_method("new", function!(Color::new, 3))?;
  colorc.define_method("r", method!(Color::r, 0))?;
  colorc.define_method("g", method!(Color::g, 0))?;
  colorc.define_method("b", method!(Color::b, 0))?;

  colorc.define_method("rgb", method!(Color::rgb, 0))?;
  colorc.define_method("hex", method!(Color::hex, 0))?;

  colorc.define_method("clone", method!(Color::clone, 0))?;
  colorc.define_method("dup", method!(Color::clone, 0))?;

  colorc.define_alias("to_rgb", "rgb")?;
  colorc.define_alias("to_hex", "hex")?;

  let imagec = module.define_class("Image", ruby.class_object())?;

  imagec.define_singleton_method("new", function!(Image::new, 1))?;
  imagec.define_method("histogram", method!(Image::histogram, 1))?;
  imagec.define_method("mediancut", method!(Image::mediancut, 1))?;
  imagec.define_method("kmeans", method!(Image::kmeans, 1))?;

  imagec.define_method("clone", method!(Image::clone, 0))?;
  imagec.define_method("dup", method!(Image::clone, 0))?;

  Ok(())
}
