## 1.1.5

- Migrated to use widget stack instead of states for easier extension into Web3Modal
- Opened up modal service to allow for a start widget to be passed in
- Added WalletConnectModalServices class to cleanly expose all available services
- Updated to `walletconnect_flutter_v2` v2.0.16

## 1.1.4

- Modal now regenerates the WC URI when you tap on a wallet or open the QR Code
- Other minor bug fixes

## 1.1.3

- Updated to `walletconnect_flutter_v2` v2.0.15
- Additional tests to ensure robustness
- Example app updates

## 1.1.2

- Updated to `walletconnect_flutter_v2` v2.0.13
- UI Updates

## 1.1.1

- Updated the URL launching and added a full test suite
- UI updates to be more in line with official WalletConnect design
- Bug fixes

## 1.1.0

- WalletConnectModalTheme widget no longer required, the default theme is light mode, to override this a `WalletConnectModalTheme` widget must be used.
- Fixed issues with `wc://` deep links.
- Multiple bug fixes.
- Tests added for major paths of each widget and service.

## 1.0.0

- Initial release
