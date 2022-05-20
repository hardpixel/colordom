use std::os::raw::c_char;
use std::ffi::{CStr, CString};

use image;
use dominant_color;
use kmeans_colors;

use palette_extract::{Quality, MaxColors, PixelEncoding, PixelFilter};
use palette::{FromColor, IntoColor, Lab, Pixel, Srgb};

fn to_string(unsafe_string: *const c_char) -> String {
  unsafe { CStr::from_ptr(unsafe_string) }.to_str().unwrap().to_string()
}

fn to_char(string: String) -> *mut c_char {
  CString::new(string).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn to_histogram(path: *const c_char) -> *mut c_char {
  let img = match image::open(&to_string(path)) {
    Ok(res) => res,
    Err(ex) => return to_char(format!("Colordom::Error {:?}", ex.to_string()))
  };

  let has_alpha = match img.color() {
    image::ColorType::Rgba8 => true,
    image::ColorType::Rgba16 => true,
    image::ColorType::Rgba32F => true,
    _ => false
  };

  let pixels = img.as_bytes();
  let result = dominant_color::get_colors(&pixels, has_alpha);

  return to_char(format!("{:?}", result));
}

#[no_mangle]
pub extern "C" fn to_mediancut(path: *const c_char, max_colors: u8) -> *mut c_char {
  let img = match image::open(&to_string(path)) {
    Ok(res) => res,
    Err(ex) => return to_char(format!("Colordom::Error {:?}", ex.to_string()))
  };

  let pixels = img.as_bytes();
  let result = palette_extract::get_palette_with_options(
    &pixels,
    PixelEncoding::Rgb,
    Quality::default(),
    MaxColors::new(max_colors),
    PixelFilter::None
  );

  return to_char(format!("{:?}", result))
}

#[no_mangle]
pub extern "C" fn to_kmeans(path: *const c_char, max_colors: usize) -> *mut c_char {
  let img = match image::open(&to_string(path)) {
    Ok(res) => res,
    Err(ex) => return to_char(format!("Colordom::Error {:?}", ex.to_string()))
  };

  let pixels = img.as_bytes();
  let max_iterations = 20;
  let converge = 1.0;
  let verbose = false;
  let seed: u64 = 0;

  let lab: Vec<Lab> = Srgb::from_raw_slice(&pixels)
    .iter()
    .map(|x| x.into_format().into_color())
    .collect();

  let run_result = kmeans_colors::get_kmeans_hamerly(
    max_colors,
    max_iterations,
    converge,
    verbose,
    &lab,
    seed
  );

  let result = &run_result.centroids
    .iter()
    .map(|x| Srgb::from_color(*x).into_format())
    .collect::<Vec<Srgb<u8>>>();

  return to_char(format!("{:?}", result))
}

#[no_mangle]
pub extern "C" fn free_result(string: *mut c_char) {
  unsafe {
    if string.is_null() { return }
    CString::from_raw(string)
  };
}
