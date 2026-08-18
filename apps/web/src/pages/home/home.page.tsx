import { HomeCta } from "./home-cta";
import { HomeFeatures } from "./home-features";
import { HomeHero } from "./home-hero";

export function HomePage() {
  return (
    <>
      <HomeHero />
      <HomeFeatures />
      <HomeCta />
    </>
  );
}