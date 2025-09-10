
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("HealthcarePlatformModule", (m) => {
  const healthcare = m.contract("HealthcarePlatform");



  return { healthcare };
});
